import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:build/build.dart' show BuildStep;
import 'package:embed/src/common/errors.dart';
import 'package:path/path.dart' as p;

File resolveContent(
  String path,
  InputSourceFilePathProvider source,
  String packageRoot,
) {
  final resolvedPath = resolvePath(path, source, packageRoot);
  final content = File(resolvedPath);
  return switch (content.existsSync()) {
    true => content,
    false => throw UsageError('No such file exists: $path'),
  };
}

/// Signature of a callback that returns the path of the input source file
/// associated with the current [BuildStep], relative to the package root
/// directory.
typedef InputSourceFilePathProvider = String Function();

/// Get the absolute path to the root directory of [package].
///
/// The result is cached, since otherwise `package_config.json` would be read
/// and parsed once per annotation.
///
/// Falls back to [p.current] when [package] is not listed in
/// `package_config.json`. This is the case with `testBuilder` from
/// `package:build_test`, which builds a synthetic package.
String packageRootOf(String package) =>
    _packageRoots[package] ??= _lookUpPackageRoot(package) ?? p.current;

final _packageRoots = <String, String>{};

String? _lookUpPackageRoot(String package) {
  final configUri = Isolate.packageConfigSync;
  if (configUri == null || configUri.scheme != 'file') return null;
  final configFile = File.fromUri(configUri);
  if (!configFile.existsSync()) return null;

  final config =
      jsonDecode(configFile.readAsStringSync()) as Map<String, Object?>;
  for (final entry in config['packages']! as List<Object?>) {
    final map = entry! as Map<String, Object?>;
    if (map['name'] != package) continue;
    // `rootUri` is resolved against the `package_config.json` file itself.
    final rootUri = configUri.resolve(map['rootUri']! as String);
    if (rootUri.scheme != 'file') return null;
    return p.canonicalize(rootUri.toFilePath());
  }
  return null;
}

/// Convert the given file [path] to an absolute path.
///
/// If [path] is a relative path, this function assumes that [path] is
/// relative to the directory containing the [source] file.
///
/// if [path] is an absolute path, it is treated as relative
/// to the package root directory.
///
/// [packageRoot] must be the absolute path to the root directory of the
/// package that owns the [source] file. It cannot be assumed to be the current
/// working directory, because `build_runner` runs in the workspace root
/// directory when it is started there in a pub workspace.
String resolvePath(
  String path,
  InputSourceFilePathProvider source,
  String packageRoot,
) {
  final resolved = switch (p.isAbsolute(path)) {
    true => changeRootDirectory(path, packageRoot),
    false => resolvePathRelativeToSource(
        relativePath: path,
        absoluteSourcePath: p.join(packageRoot, source()),
      ),
  };
  return p.canonicalize(resolved);
}

/// Convert [relativePath] to an absolute path.
///
/// [relativePath] must be a path that is relative to [absoluteSourcePath],
/// and [absoluteSourcePath] must be a path to a file.
String resolvePathRelativeToSource({
  required String relativePath,
  required String absoluteSourcePath,
}) {
  final sourceParent = p.dirname(absoluteSourcePath);
  return p.join(sourceParent, relativePath);
}

/// Change the root directory of [path] to [newRoot].
///
/// For example, the following will returns a new absolute path `/new/root/a/b/c.txt`.
/// ```dart
/// changeRootDirectory("/a/b/c.txt", "/new/root");
/// ```
/// [path] and [newRoot] must be absolute paths.
String changeRootDirectory(String path, String newRoot) {
  assert(p.isAbsolute(path));
  assert(p.isAbsolute(newRoot));
  return p.joinAll([
    newRoot,
    ...p.split(path).skip(1),
  ]);
}

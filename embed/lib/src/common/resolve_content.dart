import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:build/build.dart';
import 'package:embed/src/common/embedded_content.dart';
import 'package:embed/src/common/errors.dart';
import 'package:path/path.dart' as p;

/// Documentation on how to declare additional sources in `build.yaml`.
const _additionalSourcesUrl =
    'https://pub.dev/packages/build_config#how-can-i-include-additional-sources-in-my-build';

/// Resolve the file at [path] into an [EmbeddedContent].
///
/// The file is read through [buildStep] whenever `build_runner` is able to
/// read it as an asset, so that it is registered as an input of the current
/// build step. Otherwise, the file is read directly with `dart:io` and a
/// warning is logged, because `build_runner` cannot detect changes to a file
/// that it does not read as an asset.
Future<EmbeddedContent> resolveContent(String path, BuildStep buildStep) async {
  final package = buildStep.inputId.package;
  final packageRoot = packageRootOf(package);
  final resolvedPath =
      resolvePath(path, () => buildStep.inputId.path, packageRoot);

  final assetId = resolveAssetId(resolvedPath, package, packageRoot);
  if (assetId != null && await buildStep.canRead(assetId)) {
    return EmbeddedContent.asset(assetId, buildStep);
  }

  final content = File(resolvedPath);
  if (!content.existsSync()) {
    throw UsageError('No such file exists: $path');
  }

  if (assetId == null) {
    log.warning(
      "'$path' is outside the package root directory, so build_runner "
      'cannot track it. The generated code will not be updated when the '
      'content of the file changes.',
    );
  } else {
    final sourceGlob = switch (p.dirname(assetId.path)) {
      '.' => assetId.path,
      final directory => '$directory/**',
    };
    log.warning(
      "'$path' is not included in the sources of the build target, so "
      'build_runner cannot track it. The generated code will not be '
      'updated when the content of the file changes. To fix this, add '
      "'$sourceGlob' to the sources of the \$default target in build.yaml. "
      'See $_additionalSourcesUrl for details.',
    );
  }

  return EmbeddedContent.file(content);
}

/// Convert [absolutePath] into an [AssetId] of [package].
///
/// Returns `null` if the file is outside [packageRoot], the absolute path to
/// the root directory of [package], since such a file cannot be represented
/// as an [AssetId].
AssetId? resolveAssetId(
  String absolutePath,
  String package,
  String packageRoot,
) {
  final relativePath = p.relative(absolutePath, from: packageRoot);
  if (p.isAbsolute(relativePath) || p.split(relativePath).first == '..') {
    return null;
  }
  // AssetId paths always use POSIX separators.
  return AssetId(package, p.url.joinAll(p.split(relativePath)));
}

/// Signature of a callback that returns the path of the input source file
/// associated with the current [BuildStep], relative to the package root
/// directory.
typedef InputSourceFilePathProvider = String Function();

/// Get the absolute path to the root directory of [package].
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
    // For local packages, rootUri is relative to the package_config.json.
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

import 'dart:io';

import 'package:build/build.dart';
import 'package:embed/src/common/embedded_content.dart';
import 'package:embed/src/common/errors.dart';
import 'package:path/path.dart' as p;

/// Resolve the file at [path] into an [EmbeddedContent].
///
/// The file is read through [buildStep] whenever `build_runner` is able to
/// read it as an asset, so that it is registered as an input of the current
/// build step. Otherwise, the file is read directly with `dart:io`.
Future<EmbeddedContent> resolveContent(String path, BuildStep buildStep) async {
  final resolvedPath = resolvePath(path, () => buildStep.inputId.path);

  final assetId = resolveAssetId(resolvedPath, buildStep.inputId.package);
  if (assetId != null && await buildStep.canRead(assetId)) {
    return EmbeddedContent.asset(assetId, buildStep);
  }

  final content = File(resolvedPath);
  return switch (content.existsSync()) {
    true => EmbeddedContent.file(content),
    false => throw UsageError('No such file exists: $path'),
  };
}

/// Convert [absolutePath] into an [AssetId] of [package].
///
/// Returns `null` if the file is outside the package root directory, since
/// such a file cannot be represented as an [AssetId].
///
/// This function assumes that `build_runner` is run in the package root.
AssetId? resolveAssetId(String absolutePath, String package) {
  final relativePath = p.relative(absolutePath, from: p.current);
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

/// Convert the given file [path] to an absolute path.
///
/// If [path] is a relative path, this function assumes that [path] is
/// relative to the directory containing the [source] file.
///
/// if [path] is an absolute path, it is treated as relative
/// to the package root directory.
String resolvePath(String path, InputSourceFilePathProvider source) {
  final resolved = switch (p.isAbsolute(path)) {
    true => changeRootDirectory(path, p.current),
    false => resolvePathRelativeToSource(
        relativePath: path,
        absoluteSourcePath: absoluteInputSourceFilePath(source),
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

/// Get the absolute path to the input [source] file.
///
/// This function assumes that `build_runner` is run in the package root.
String absoluteInputSourceFilePath(InputSourceFilePathProvider source) {
  final packageDir = p.current;
  final relativeSourcePath = source();
  return p.join(packageDir, relativeSourcePath);
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

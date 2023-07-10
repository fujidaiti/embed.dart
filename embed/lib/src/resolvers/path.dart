import 'package:build/build.dart';
import 'package:path/path.dart' as p;

/// Convert [path] to an absolute path.
///
/// If [path] is a relative path, this function assumes that
/// [path] is relative to the directory containing the [source] file.
String resolvePath(String path, AssetId source) {
  final resolved = switch (p.isRelative(path)) {
    true => resolvePathRelativeToSource(
        relativePath: path,
        absoluteSourcePath: inputSourcePath(source),
      ),
    false => path,
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

/// Get the absolute path to the input [source].
///
/// This function assumes that `build_runner` is run in the package root.
String inputSourcePath(AssetId source) {
  final packageDir = p.current;
  final relativeSourcePath = source.path;
  return p.join(packageDir, relativeSourcePath);
}

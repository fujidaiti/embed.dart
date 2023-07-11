import 'package:build/build.dart';
import 'package:path/path.dart' as p;

/// Convert [path] to an absolute path.
///
/// If [path] is a relative path, this function assumes that [path] is
/// relative to the directory containing the [source] file.
/// 
/// if [path] is an absolute path, it is treated as relative
/// to the package root directory.
String resolvePath(String path, AssetId source) {
  final resolved = switch (p.isAbsolute(path)) {
    true => changeRootDirectory(path, p.current),
    false => resolvePathRelativeToSource(
        relativePath: path,
        absoluteSourcePath: inputSourcePath(source),
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
String inputSourcePath(AssetId source) {
  final packageDir = p.current;
  final relativeSourcePath = source.path;
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

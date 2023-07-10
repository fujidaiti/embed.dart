import 'package:build/build.dart';
import 'package:path/path.dart' as p;

/// Convert [path] to an absolute path.
///
/// If [path] is a relative path, this function assumes that
/// [path] is relative to the directory containing the source file
/// associated with the given [buildStep].
String resolvePath(String path, BuildStep buildStep) {
  final resolved = switch (p.isRelative(path)) {
    true => resolvePathRelativeToSource(
        relativePath: path,
        absoluteSourcePath: inputSourcePath(buildStep),
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

/// Get the absolute path to the input source file associated with the [buildStep].
///
/// This function assumes that `build_runner` is run in the package root.
String inputSourcePath(BuildStep buildStep) {
  final packageDir = p.current;
  final relativeSourcePath = buildStep.inputId.path;
  return p.join(packageDir, relativeSourcePath);
}

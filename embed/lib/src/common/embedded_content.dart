import 'dart:io';
import 'dart:typed_data';

import 'package:build/build.dart';

/// The content of a file to be embedded.
///
/// There are two ways to read the content:
///
/// - [EmbeddedContent.asset] reads the file through the [BuildStep], which
///   registers the file as an input of the current build step. `build_runner`
///   then regenerates the output whenever the file content changes.
/// - [EmbeddedContent.file] reads the file directly with `dart:io`. This is
///   the fallback for files that `build_runner` cannot read as an asset
///   (see `resolveAssetId` for the conditions). Changes to such files are not
///   detected by `build_runner`.
abstract class EmbeddedContent {
  const EmbeddedContent();

  factory EmbeddedContent.asset(AssetId id, BuildStep buildStep) =
      _AssetContent;

  factory EmbeddedContent.file(File file) = _FileContent;

  /// The absolute path of the file, used to determine the file extension.
  String get path;

  Future<String> readAsString();

  Future<Uint8List> readAsBytes();
}

class _AssetContent extends EmbeddedContent {
  const _AssetContent(this.id, this.buildStep);

  final AssetId id;
  final BuildStep buildStep;

  @override
  String get path => id.path;

  @override
  Future<String> readAsString() => buildStep.readAsString(id);

  @override
  Future<Uint8List> readAsBytes() async =>
      Uint8List.fromList(await buildStep.readAsBytes(id));
}

class _FileContent extends EmbeddedContent {
  const _FileContent(this.file);

  final File file;

  @override
  String get path => file.path;

  @override
  Future<String> readAsString() => file.readAsString();

  @override
  Future<Uint8List> readAsBytes() => file.readAsBytes();
}

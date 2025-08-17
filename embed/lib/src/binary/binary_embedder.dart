import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:analyzer/dart/element/element2.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';

class BinaryEmbedder extends Embedder<EmbedBinary> {
  const BinaryEmbedder(super.config);

  @override
  FutureOr<String> getEmbeddingOf(
      File content, TopLevelVariableElement2 element) async {
    final bytes = await content.readAsBytes();
    if (config.base64) {
      return _encodeBase64(bytes);
    }
    return _encodeAsList(bytes);
  }

  String _encodeAsList(Uint8List bytes) => '$bytes';

  String _encodeBase64(Uint8List bytes) => "'${base64.encode(bytes)}'";
}

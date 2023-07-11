import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:embed/src/embedders/embedder.dart';
import 'package:embed/src/utils/primitives.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:path/path.dart' as p;

class LiteralEmbedder extends Embedder<EmbedLiteral> {
  const LiteralEmbedder(super.config);

  @override
  FutureOr<String> getEmbeddingOf(File content) async {
    final value = await _parse(content);
    return literalOf(value);
  }

  Future<dynamic> _parse(File content) async {
    final stringContent = await content.readAsString();
    final fileExtension = p.extension(content.path);
    return switch (fileExtension) {
      ".json" => jsonDecode(stringContent),
      _ => ArgumentError.value(content, "content",
          "$EmbedLiteral does not support '*$fileExtension'"),
    };
  }
}

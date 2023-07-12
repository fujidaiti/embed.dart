import 'dart:async';
import 'dart:io';

import 'package:embed/src/embedders/embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';

class StringEmbedder extends Embedder<EmbedStr> {
  const StringEmbedder(super.config);

  @override
  FutureOr<String> getEmbeddingOf(File content) async {
    final string = await content.readAsString();
    final r = config.raw ? "r" : "";
    return "$r'''\n$string\n'''";
  }
}

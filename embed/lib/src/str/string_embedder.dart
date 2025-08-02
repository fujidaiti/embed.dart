import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element2.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';

class StringEmbedder extends Embedder<EmbedStr> {
  const StringEmbedder(super.config);

  @override
  FutureOr<String> getEmbeddingOf(
      File content, TopLevelVariableElement2 element) async {
    final string = await content.readAsString();
    final r = config.raw ? "r" : "";
    return "$r'''\n$string\n'''";
  }
}

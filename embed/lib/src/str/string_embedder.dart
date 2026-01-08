// Ignore deprecated_member_use in order to support a wider range of build and
// source_gen

import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';

class StringEmbedder extends Embedder<EmbedStr> {
  const StringEmbedder(super.config);

  @override
  FutureOr<String> getEmbeddingOf(
      File content, TopLevelVariableElement element) async {
    final string = await content.readAsString();
    final r = config.raw ? 'r' : '';
    return "$r'''\n$string\n'''";
  }
}

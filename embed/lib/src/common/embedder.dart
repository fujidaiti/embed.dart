import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:embed_annotation/embed_annotation.dart';

abstract class Embedder<E extends Embed> {
  const Embedder(this.config);

  final E config;

  FutureOr<String> getEmbeddingOf(
    File content,
    TopLevelVariableElement element,
  );
}

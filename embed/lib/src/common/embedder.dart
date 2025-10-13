// Ignore deprecated_member_use in order to support a wider range of build and
// source_gen
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element2.dart';
import 'package:embed_annotation/embed_annotation.dart';

abstract class Embedder<E extends Embed> {
  const Embedder(this.config);

  final E config;

  FutureOr<String> getEmbeddingOf(
    File content,
    TopLevelVariableElement2 element,
  );
}

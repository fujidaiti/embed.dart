import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:embed/src/common/resolve_content.dart';
import 'package:embed/src/common/usage_error.dart';
import 'package:embed/src/embedders/embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

abstract class EmbedGenerator<E extends Embed>
    extends GeneratorForAnnotation<E> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    if (element.kind != ElementKind.TOP_LEVEL_VARIABLE) {
      throw InvalidGenerationSourceError(
        "Only top level variables can be annotated with $E",
        element: element,
      );
    }

    try {
      return await _run(element, annotation, buildStep);
    } on Error catch (error, stackTrace) {
      final message = switch (error) {
        UsageError error => error.message,
        _ => "$error",
      };
      throw Error.throwWithStackTrace(
        InvalidGenerationSourceError(message, element: element),
        stackTrace,
      );
    }
  }

  Future<String> _run(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    String inputSourceFilePath() => buildStep.inputId.path;
    final embedder = createEmbedderFrom(annotation);
    final content = resolveContent(embedder.config.path, inputSourceFilePath);

    final variable = "_\$${element.name}";
    final embedding = await embedder.getEmbeddingOf(content);
    return "const $variable = $embedding;";
  }

  Embedder<E> createEmbedderFrom(ConstantReader annotation);
}

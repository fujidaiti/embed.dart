import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:embed/src/embedders/embedder.dart';
import 'package:embed/src/resolvers/content.dart';
import 'package:embed/src/resolvers/path.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

abstract class EmbedGenerator<E extends Embed>
    extends GeneratorForAnnotation<E> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    if (element.kind != ElementKind.TOP_LEVEL_VARIABLE) {
      throw InvalidGenerationSourceError(
        "Only top level variables can be annotated with ${E}s",
        element: element,
      );
    }

    try {
      return await _run(element, annotation, buildStep);
    } on Error catch (error, stackTrace) {
      throw Error.throwWithStackTrace(
        InvalidGenerationSourceError("$error", element: element),
        stackTrace,
      );
    }
  }

  Future<String> _run(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    String inputSourceFilePath() => buildStep.inputId.path;
    final embedder = createEmbedderFrom(annotation);
    final contentPath = resolvePath(embedder.config.path, inputSourceFilePath);
    final content = resolveContent(contentPath);

    final variable = "_\$${element.name}";
    final embedding = await embedder.getEmbeddingOf(content);
    return "const $variable = $embedding;";
  }

  Embedder<E> createEmbedderFrom(ConstantReader annotation);
}
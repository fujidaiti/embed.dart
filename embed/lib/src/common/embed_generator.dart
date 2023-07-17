import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:embed/src/common/resolve_content.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

abstract class EmbedGenerator<E extends Embed>
    extends GeneratorForAnnotation<E> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    if (element is! TopLevelVariableElement) {
      throw InvalidGenerationSourceError(
        "Only top level variables can be annotated with $E",
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
    TopLevelVariableElement element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    String inputSourceFilePath() => buildStep.inputId.path;
    final embedder = createEmbedderFrom(annotation);
    final content = resolveContent(embedder.config.path, inputSourceFilePath);

    final variable = "_\$${element.name}";
    final embedding = await embedder.getEmbeddingOf(content, element);
    return "const $variable = $embedding;";
  }

  Embedder<E> createEmbedderFrom(ConstantReader annotation);
}

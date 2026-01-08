// Ignore deprecated_member_use in order to support a wider range of build and
// source_gen

import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed/src/common/resolve_content.dart' as r;
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

abstract class EmbeddingGenerator<E extends Embed>
    extends GeneratorForAnnotation<E> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    if (element is! TopLevelVariableElement) {
      throw InvalidGenerationSourceError(
        'Only top level variables can be annotated with $E',
        element: element,
      );
    }

    try {
      return await _run(element, annotation, buildStep);
    } on Exception catch (error) {
      throw InvalidGenerationSourceError('$error', element: element);
    }
  }

  Future<String> _run(
    TopLevelVariableElement element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final embedder = createEmbedderFrom(annotation);
    final content = resolveContent(embedder.config, buildStep);
    final variable = '_\$${element.name}';
    final embedding = await embedder.getEmbeddingOf(content, element);
    return 'const $variable = $embedding;';
  }

  File resolveContent(E config, BuildStep buildStep) {
    String inputSourceFilePath() => buildStep.inputId.path;
    return r.resolveContent(config.path, inputSourceFilePath);
  }

  Embedder<E> createEmbedderFrom(ConstantReader annotation);
}

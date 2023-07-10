import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:embed/src/resolvers/content.dart';
import 'package:embed/src/resolvers/embedder.dart';
import 'package:embed/src/resolvers/path.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

class EmbedGenerator extends GeneratorForAnnotation<Embed> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final embedder = resolveEmbedder(annotation);
    final contentPath = resolvePath(embedder.config.path, buildStep.inputId);
    final content = resolveContent(contentPath);

    final variable = "_\$${element.name}";
    final embedding = await embedder.getEmbeddingOf(content);
    return "const $variable = $embedding;";
  }
}

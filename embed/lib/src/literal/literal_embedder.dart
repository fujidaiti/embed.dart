// Ignore deprecated_member_use in order to support a wider range of build and
// source_gen

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed/src/common/errors.dart';
import 'package:embed/src/literal/pattern_matching.dart';
import 'package:embed/src/literal/preprocessing.dart';
import 'package:embed/src/literal/type_constraints.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:toml/toml.dart';
import 'package:yaml/yaml.dart';

class LiteralEmbedder extends Embedder<EmbedLiteral> {
  const LiteralEmbedder(super.config);

  @override
  FutureOr<String> getEmbeddingOf(
      File content, TopLevelVariableElement element) async {
    final value = await _parse(content);
    final expectedType = TypeConstraint.from(element.type);
    final preprocessed = Preprocessing(config.preprocessors).applyTo(value);
    return match(preprocessed, expectedType).toString();
  }

  Future<dynamic> _parse(File content) async {
    final stringContent = await content.readAsString();
    final fileExtension = p.extension(content.path);
    return switch (fileExtension) {
      '.json' => jsonDecode(stringContent),
      '.yaml' || '.yml' => loadYaml(stringContent),
      '.toml' => TomlDocument.parse(stringContent).toMap(),
      _ => UsageError('Invalid file extension: $EmbedLiteral '
          "does not support '*$fileExtension'"),
    };
  }
}

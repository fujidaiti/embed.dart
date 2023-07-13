import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:embed/src/embedders/embedder.dart';
import 'package:embed/src/embedders/primitives/primitives.dart';
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
    return literalOf(value);
  }

  Future<dynamic> _parse(File content) async {
    final stringContent = await content.readAsString();
    final fileExtension = p.extension(content.path);
    return switch (fileExtension) {
      ".json" => jsonDecode(stringContent),
      ".yaml" || ".yml" => loadYaml(stringContent),
      ".toml" => TomlDocument.parse(stringContent).toMap(),
      _ => ArgumentError.value(content, "content",
          "$EmbedLiteral does not support '*$fileExtension'"),
    };
  }
}

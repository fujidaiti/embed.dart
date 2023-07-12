import 'package:embed/src/embedders/embedder.dart';
import 'package:embed/src/embedders/string_embedder.dart';
import 'package:embed/src/generators/embed_generator.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

class EmbedStrGenerator extends EmbedGenerator<EmbedStr> {
  @override
  Embedder<EmbedStr> createEmbedderFrom(ConstantReader annotation) {
    assert(annotation.instanceOf(TypeChecker.fromRuntime(EmbedStr)));
    return StringEmbedder(EmbedStr(
      annotation.read("path").stringValue,
      raw: annotation.read("raw").boolValue,
    ));
  }
}

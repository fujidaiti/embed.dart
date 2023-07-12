import 'package:embed/src/embedders/embedder.dart';
import 'package:embed/src/embedders/literal_embedder.dart';
import 'package:embed/src/generators/embed_generator.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

class EmbedLiteralGenerator extends EmbedGenerator<EmbedLiteral> {
  @override
  Embedder<EmbedLiteral> createEmbedderFrom(ConstantReader annotation) {
    assert(annotation.instanceOf(TypeChecker.fromRuntime(EmbedLiteral)));
    return LiteralEmbedder(EmbedLiteral(annotation.read("path").stringValue));
  }
}

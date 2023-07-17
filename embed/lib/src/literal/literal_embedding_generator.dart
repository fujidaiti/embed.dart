import 'package:embed/src/common/embed_generator.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed/src/literal/literal_embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

class LiteralEmbeddingGenerator extends EmbeddingGenerator<EmbedLiteral> {
  @override
  Embedder<EmbedLiteral> createEmbedderFrom(ConstantReader annotation) {
    assert(annotation.instanceOf(TypeChecker.fromRuntime(EmbedLiteral)));
    return LiteralEmbedder(EmbedLiteral(annotation.read("path").stringValue));
  }
}

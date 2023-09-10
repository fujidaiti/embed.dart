import 'package:embed/src/binary/binary_embedder.dart';
import 'package:embed/src/common/embed_generator.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

class BinaryEmbeddingGenerator extends EmbeddingGenerator<EmbedBinary> {
  @override
  Embedder<EmbedBinary> createEmbedderFrom(ConstantReader annotation) {
    assert(annotation.instanceOf(TypeChecker.fromRuntime(EmbedBinary)));
    return BinaryEmbedder(EmbedBinary(
      annotation.read("path").stringValue,
      base64: annotation.read("base64").boolValue,
    ));
  }
}

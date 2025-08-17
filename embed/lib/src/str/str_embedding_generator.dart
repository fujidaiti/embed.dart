import 'package:embed/src/common/embed_generator.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed/src/str/string_embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

class StrEmbeddingGenerator extends EmbeddingGenerator<EmbedStr> {
  @override
  Embedder<EmbedStr> createEmbedderFrom(ConstantReader annotation) {
    assert(annotation.instanceOf(
        const TypeChecker.typeNamed(EmbedStr, inPackage: 'embed_annotation')));
    return StringEmbedder(EmbedStr(
      annotation.read('path').stringValue,
      raw: annotation.read('raw').boolValue,
    ));
  }
}

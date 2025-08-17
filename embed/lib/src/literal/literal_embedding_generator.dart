import 'package:embed/src/common/embed_generator.dart';
import 'package:embed/src/common/embedder.dart';
import 'package:embed/src/common/errors.dart';
import 'package:embed/src/literal/literal_embedder.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

class LiteralEmbeddingGenerator extends EmbeddingGenerator<EmbedLiteral> {
  @override
  Embedder<EmbedLiteral> createEmbedderFrom(ConstantReader annotation) {
    assert(annotation.instanceOf(const TypeChecker.typeNamed(EmbedLiteral,
        inPackage: 'embed_annotation')));
    final contentPath = annotation.read('path').stringValue;
    final preprocessors = annotation
        .read('preprocessors')
        .listValue
        .map(ConstantReader.new)
        .map(_readPreprocessor)
        .toList(growable: false);

    return LiteralEmbedder(
      EmbedLiteral(
        contentPath,
        preprocessors: preprocessors,
      ),
    );
  }
}

Preprocessor _readPreprocessor(ConstantReader reader) {
  if (reader.instanceOf(
      const TypeChecker.typeNamed(Recase, inPackage: 'embed_annotation'))) {
    return Preprocessor.recase;
  }
  if (reader.instanceOf(const TypeChecker.typeNamed(EscapeReservedKeywords,
      inPackage: 'embed_annotation'))) {
    return Preprocessor.escapeReservedKeywords;
  }
  if (reader.instanceOf(
      const TypeChecker.typeNamed(Replace, inPackage: 'embed_annotation'))) {
    return Replace(
      reader.read('pattern').stringValue,
      reader.read('replacement').stringValue,
      onlyFirst: reader.read('onlyFirst').boolValue,
    );
  }
  throw ShouldNeverBeHappenError();
}

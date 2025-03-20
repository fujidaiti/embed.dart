import 'package:build/build.dart';
import 'package:embed/src/binary/binary_embedding_generator.dart';
import 'package:embed/src/literal/literal_embedding_generator.dart';
import 'package:embed/src/str/str_embedding_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Creates a builder for @Embed annotations.
Builder embedBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [
      StrEmbeddingGenerator(),
      LiteralEmbeddingGenerator(),
      BinaryEmbeddingGenerator(),
    ],
    "embed",
  );
}

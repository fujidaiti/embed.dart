library embed;

import 'package:build/build.dart';
import 'package:embed/src/generators/embed_literal_generator.dart';
import 'package:embed/src/generators/embed_str_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder embedBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [
      EmbedStrGenerator(),
      EmbedLiteralGenerator(),
    ],
    "embed",
  );
}

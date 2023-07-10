library embed;

import 'package:build/build.dart';
import 'package:embed/src/embed_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder embedBuilder(BuilderOptions options) =>
    SharedPartBuilder([EmbedGenerator()], "embed");

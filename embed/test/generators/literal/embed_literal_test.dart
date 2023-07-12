import 'package:embed/src/generators/embed_literal_generator.dart';
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  final libraryReader = await initializeLibraryReaderForDirectory(
    "test/generators/literal",
    "embed_literal_test_src.dart",
  );

  initializeBuildLogTracking();
  testAnnotatedElements(libraryReader, EmbedLiteralGenerator());
}

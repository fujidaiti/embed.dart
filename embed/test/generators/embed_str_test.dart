import 'package:embed/src/generators/embed_str_generator.dart';
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  final libraryReader = await initializeLibraryReaderForDirectory(
    "test/src/",
    "embed_str.dart",
  );

  initializeBuildLogTracking();
  testAnnotatedElements(libraryReader, EmbedStrGenerator());
}

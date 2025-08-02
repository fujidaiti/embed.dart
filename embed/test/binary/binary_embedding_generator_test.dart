import 'package:embed/src/binary/binary_embedding_generator.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';

import '../utils/test_annotation.dart';
import '../utils/test_generator_mixin.dart';

Future<void> main() async {
  final libraryReader = await initializeLibraryReaderForDirectory(
    "test/binary",
    "binary_embedding_generator_test.dart",
  );

  initializeBuildLogTracking();
  testAnnotatedElements(libraryReader, _TestGenerator());
}

class _TestGenerator extends BinaryEmbeddingGenerator with TestGeneratorMixin {
  @override
  List<String> get additionalAnnotationFields => const ["base64"];
}

class TestBinary extends ShouldGenerate implements TestAnnotation, EmbedBinary {
  const TestBinary({
    required this.extension,
    required this.content,
    required String shouldGenerate,
    this.base64 = false,
  }) : super(shouldGenerate);

  @override
  final String extension;

  @override
  final List<int> content;

  @override
  final bool base64;

  @override
  String get path => throw UnimplementedError();
}

/* -------------------------------------------------------------------------- */
/*                                    TESTS                                   */
/* -------------------------------------------------------------------------- */

// The content should be embedded as is.
@TestBinary(
  extension: "dat",
  content: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  shouldGenerate: r"""
const _$embedAsList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
""",
)
dynamic embedAsList;

// The content should be embedded as base64
@TestBinary(
  extension: "dat",
  content: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  base64: true,
  shouldGenerate: r"""
const _$embedAsBase64 = 'AQIDBAUGBwgJCg==';
""",
)
dynamic embedAsBase64;

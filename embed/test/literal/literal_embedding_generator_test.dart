// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:embed/src/literal/literal_embedding_generator.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';

import '../utils/test_annotation.dart';
import '../utils/test_generator_mixin.dart';

Future<void> main() async {
  final libraryReader = await initializeLibraryReaderForDirectory(
    "test/literal",
    "literal_embedding_generator_test.dart",
  );

  initializeBuildLogTracking();
  testAnnotatedElements(libraryReader, _TestGenerator());
}

class _TestGenerator extends LiteralEmbeddingGenerator with TestGeneratorMixin {
  @override
  List<String> get additionalAnnotationFields => const ["preprocessors"];
}

class _TestEmbedLiteral extends ShouldGenerate
    implements TestAnnotation, EmbedLiteral {
  const _TestEmbedLiteral({
    required this.extension,
    required this.content,
    required String shouldGenerate,
    this.preprocessors = const [],
  }) : super(shouldGenerate);

  @override
  final String extension;

  @override
  final String content;

  @override
  final List<Preprocessor> preprocessors;

  @override
  String get path => throw UnimplementedError();
}

@_TestEmbedLiteral(
  extension: "json",
  content: '{ "a": 0 }',
  shouldGenerate: r"""
const _$integerLiterals = (a: 0);
""",
)
var integerLiterals;

@_TestEmbedLiteral(
  extension: "json",
  content: '{ "a": "0xffffffff" }',
  shouldGenerate: r"""
const _$hexDecimalIntegerLiteral = {"a": 0xffffffff};
""",
)
Map<String, int>? hexDecimalIntegerLiteral;

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:embed/src/str/str_embedding_generator.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';

import '../utils/test_annotation.dart';
import '../utils/test_generator_mixin.dart';

Future<void> main() async {
  final libraryReader = await initializeLibraryReaderForDirectory(
    "test/str",
    "str_embedding_generator_test.dart",
  );

  initializeBuildLogTracking();
  testAnnotatedElements(libraryReader, _TestGenerator());
}

class _TestGenerator extends StrEmbeddingGenerator with TestGeneratorMixin {
  @override
  List<String> get additionalAnnotationFields => const ["raw"];
}

class TestStrLiteral extends ShouldGenerate
    implements TestAnnotation, EmbedStr {
  const TestStrLiteral({
    required this.extension,
    required this.content,
    required String shouldGenerate,
    this.raw = true,
  }) : super(shouldGenerate);

  @override
  final String extension;

  @override
  final String content;

  @override
  final bool raw;

  @override
  String get path => throw UnimplementedError();
}

/* -------------------------------------------------------------------------- */
/*                                    TESTS                                   */
/* -------------------------------------------------------------------------- */

// The content should be embedded as is.
@TestStrLiteral(
  extension: "txt",
  content: "This is a single line text",
  shouldGenerate: r"""
const _$singleLine = r'''
This is a single line text
''';
""",
)
var singleLine;

// The content should be embedded as is, even if it has multiple lines.
@TestStrLiteral(
  extension: "txt",
  content: r"""
The first line of the multi-line text
The second line of the multi-line text""",
  shouldGenerate: r"""
const _$multiLine = r'''
The first line of the multi-line text
The second line of the multi-line text
''';
""",
)
var multiLine;

// Leading and trailing blank lines should be preserved.
@TestStrLiteral(
  extension: "json",
  content: r"""

This file contains a leading blank line
and a trailing blank line.
""",
  shouldGenerate: r"""
const _$textWithBlankLines = r'''

This file contains a leading blank line
and a trailing blank line.

''';
""",
)
var textWithBlankLines;

// Content should be able to contain quotation marks.
@TestStrLiteral(
  extension: "txt",
  content: r"""a "b" c 'd' e \"f\'""",
  shouldGenerate: r"""
const _$quotationMarks = r'''
a "b" c 'd' e \"f\'
''';
""",
)
var quotationMarks;

// Content should be embedded as a regular string literal.
@TestStrLiteral(
  raw: false,
  extension: "txt",
  content: "This is a single line text",
  shouldGenerate: r"""
const _$regularStringLiteral = '''
This is a single line text
''';
""",
)
var regularStringLiteral;

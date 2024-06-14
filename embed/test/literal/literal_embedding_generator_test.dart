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
  testAnnotatedElements(libraryReader, TestGenerator());
}

class TestGenerator extends LiteralEmbeddingGenerator with TestGeneratorMixin {
  @override
  List<String> get additionalAnnotationFields => const ["preprocessors"];
}

class TestEmbedLiteral extends ShouldGenerate
    implements TestAnnotation, EmbedLiteral {
  const TestEmbedLiteral({
    required this.extension,
    required this.content,
    required String shouldGenerate,
    this.preprocessors = const [
      Preprocessor.recase,
      Preprocessor.escapeReservedKeywords,
    ],
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

/* -------------------------------------------------------------------------- */
/*                                    TESTS                                   */
/* -------------------------------------------------------------------------- */

@TestEmbedLiteral(
  extension: "json",
  content: '{ "a": 0 }',
  shouldGenerate: r"""
const _$integerLiterals = (a: 0);
""",
)
var integerLiterals;

@TestEmbedLiteral(
  extension: "json",
  content: '{ "a": "0xffffffff" }',
  shouldGenerate: r"""
const _$hexDecimalIntegerLiteral = {"a": 0xffffffff};
""",
)
Map<String, int>? hexDecimalIntegerLiteral;

@TestEmbedLiteral(
  extension: "json",
  content: '{ "a": 0.0, "b": -0.0 }',
  shouldGenerate: r"""
const _$floatLiterals = (a: 0.0, b: -0.0);
""",
)
var floatLiterals;

@TestEmbedLiteral(
  extension: "json",
  content: r"""
{ "a": "a", "b": "\"b\"", "c": "'c'" }
""",
  shouldGenerate: r"""
const _$stringLiterals = (a: "a", b: "\"b\"", c: "'c'");
""",
)
var stringLiterals;

@TestEmbedLiteral(
  extension: "json",
  content: '{ "a": true, "b": false }',
  shouldGenerate: r"""
const _$booleanLiterals = (a: true, b: false);
""",
)
var booleanLiterals;

@TestEmbedLiteral(
  extension: "json",
  content: '{ "a": null }',
  shouldGenerate: r"""
const _$nullLiteral = (a: null);
""",
)
var nullLiteral;

@TestEmbedLiteral(
  extension: "json",
  content: '[0, 1, 2, 3, 4, 5]',
  shouldGenerate: r"""
const _$arrayLiteral = [0, 1, 2, 3, 4, 5];
""",
)
var arrayLiteral;

@TestEmbedLiteral(
  extension: "json",
  content: '{ "a": 0, "b": 0.0, "c": true }',
  shouldGenerate: r"""
const _$recordLiteral = (a: 0, b: 0.0, c: true);
""",
)
var recordLiteral;

@TestEmbedLiteral(
  extension: "json",
  content: '{ "#": 0 }',
  shouldGenerate: r"""
const _$mapLiteral = {"#": 0};
""",
)
var mapLiteral;

// Any of the reserved Dart keywords should be prefixed with a '$' sign
// when it is used as a record field name.
@TestEmbedLiteral(
  extension: "json",
  content: r"""
{
  "assert": null,
  "break": null,
  "case": null,
  "catch": null,
  "class": null,
  "const": null,
  "continue": null,
  "default": null,
  "do": null,
  "else": null,
  "enum": null,
  "extends": null,
  "false": null,
  "final": null,
  "finally": null,
  "for": null,
  "if": null,
  "in": null,
  "is": null,
  "new": null,
  "null": null,
  "rethrow": null,
  "return": null,
  "super": null,
  "switch": null,
  "this": null,
  "throw": null,
  "true": null,
  "try": null,
  "var": null,
  "void": null,
  "when": null,
  "while": null,
  "with": null
}
""",
  shouldGenerate: r"""
const _$reservedWordsAsRecordField = (
  $assert: null,
  $break: null,
  $case: null,
  $catch: null,
  $class: null,
  $const: null,
  $continue: null,
  $default: null,
  $do: null,
  $else: null,
  $enum: null,
  $extends: null,
  $false: null,
  $final: null,
  $finally: null,
  $for: null,
  $if: null,
  $in: null,
  $is: null,
  $new: null,
  $null: null,
  $rethrow: null,
  $return: null,
  $super: null,
  $switch: null,
  $this: null,
  $throw: null,
  $true: null,
  $try: null,
  $var: null,
  $void: null,
  $when: null,
  $while: null,
  $with: null
);
""",
)
var reservedWordsAsRecordField;

@TestEmbedLiteral(
  extension: "json",
  content: "[0, 1, 2, 3, 4, 5]",
  shouldGenerate: r"""
const _$setPattern = {0, 1, 2, 3, 4, 5};
""",
)
Set? setPattern;

@TestEmbedLiteral(
  extension: "json",
  content: '{ "a": 0, "b": 0.0, "c": true }',
  shouldGenerate: r"""
const _$recordPattern = (a: 0, b: 0.0);
""",
)
({int a, double b})? recordPattern;

@TestEmbedLiteral(
  extension: "json",
  content: '{ "a": 0, "b": 0.0, "c": true }',
  shouldGenerate: r"""
const _$mapPattern = {"a": 0, "b": 0.0, "c": true};
""",
)
Map<String, dynamic>? mapPattern;

@TestEmbedLiteral(
  extension: "json",
  content: r"""
{ "dollar": "$" }
""",
  shouldGenerate: r"""
const _$stringLiteralsDollar = (dollar: "\$");
""",
)
var stringLiteralsDollar;

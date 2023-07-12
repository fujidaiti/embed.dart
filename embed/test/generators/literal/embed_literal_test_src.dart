// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';

@ShouldGenerate(r"""
const _$integerLiterals = (a: 0);
""")
@EmbedLiteral("/test/generators/literal/contents/primitives/integer.json")
var integerLiterals;

@ShouldGenerate(r"""
const _$floatLiterals = (a: 0.0, b: -0.0);
""")
@EmbedLiteral("/test/generators/literal/contents/primitives/float.json")
var floatLiterals;

@ShouldGenerate(r"""
const _$stringLiterals = (a: "a", b: "\"b\"", c: "'c'");
""")
@EmbedLiteral("/test/generators/literal/contents/primitives/string.json")
var stringLiterals;

@ShouldGenerate(r"""
const _$booleanLiterals = (a: true, b: false);
""")
@EmbedLiteral("/test/generators/literal/contents/primitives/boolean.json")
var booleanLiterals;

@ShouldGenerate(r"""
const _$nullLiteral = (a: null);
""")
@EmbedLiteral("/test/generators/literal/contents/primitives/null.json")
var nullLiteral;

@ShouldGenerate(r"""
const _$arrayLiteral = [0, 1, 2, 3, 4, 5];
""")
@EmbedLiteral("/test/generators/literal/contents/primitives/array.json")
var arrayLiteral;

// Any of the reserved Dart keywords should be prefixed with a '$' sign
// when it is used as a record field name.
@ShouldGenerate(r"""
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
""")
@EmbedLiteral("/test/generators/literal/contents/reserved_words.json")
var reservedWordsAsRecordField;
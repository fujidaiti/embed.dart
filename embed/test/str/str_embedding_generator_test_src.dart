// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen_test/annotations.dart';

// The content should be embedded as is.
@ShouldGenerate(r"""
const _$singleLine = r'''
This is a single line text
''';
""")
@EmbedStr("/test/str/contents/single_line.txt")
var singleLine;

// The content should be embedded as is, even if it has multiple lines.
@ShouldGenerate(r"""
const _$multiLine = r'''
The first line of the multi-line text
The second line of the multi-line text
''';
""")
@EmbedStr("/test/str/contents/multi_line.txt")
var multiLine;

// Leanding and trailing blank lines should be preserved.
@ShouldGenerate(r"""
const _$textWithBlankLines = r'''

This file contains a leading blank line
and a trailing blank line.

''';
""")
@EmbedStr("/test/str/contents/blank_lines.txt")
var textWithBlankLines;

// Content should be able to contain qutation marks.
@ShouldGenerate(r"""
const _$quotationMarks = r'''
a "b" c 'd' e \"f\'
''';
""")
@EmbedStr("/test/str/contents/quotation_marks.txt")
var quotationMarks;

// Content should be embedded as a regular string literal.
@ShouldGenerate(r"""
const _$regularStringLiteral = '''
This is a single line text
''';
""")
@EmbedStr("/test/str/contents/single_line.txt", raw: false)
var regularStringLiteral;

@ShouldThrow("Only top level variables can be annotated with EmbedStr")
@EmbedStr("/test/str/contents/single_line.txt")
class AnnotateClassElement {}

@ShouldThrow("No such file exists: /this/file/does/not/exist.txt")
@EmbedStr("/this/file/does/not/exist.txt")
var nonexistentFile;

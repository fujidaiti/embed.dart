class DartIdentifier {
  DartIdentifier(this.string) : assert(isValidDartIdentifier(string));

  final String string;

  @override
  String toString() => string;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DartIdentifier &&
          runtimeType == other.runtimeType &&
          string == other.string);

  @override
  int get hashCode => Object.hash(runtimeType, string);
}

/// Dart's reserved keywords defined in https://dart.dev/language/keywords.
///
// Please keep this list in alphabetical order.
const reservedDartKeywords = {
  "assert",
  "break",
  "case",
  "catch",
  "class",
  "const",
  "continue",
  "default",
  "do",
  "else",
  "enum",
  "extends",
  "false",
  "final",
  "finally",
  "for",
  "if",
  "in",
  "is",
  "new",
  "null",
  "rethrow",
  "return",
  "super",
  "switch",
  "this",
  "throw",
  "true",
  "try",
  "var",
  "void",
  "when",
  "while",
  "with",
};

final _validDartIdentifierPattern = RegExp(r"^[\$a-zA-Z_][\w\$]*$");

bool isValidDartIdentifier(String string) =>
    _validDartIdentifierPattern.hasMatch(string) &&
    !reservedDartKeywords.contains(string);

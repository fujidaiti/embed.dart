import 'package:embed/src/embedders/primitives/primitives.dart';
import 'package:embed/src/common/dart_identifier.dart';
import 'package:recase/recase.dart';

String literalOfInt(int value) => value.toString();

String literalOfDouble(double value) => value.toString();

String literalOfNull() => "null";

String literalOfBool(bool value) => value.toString();

String literalOfString(String value) {
  final literal = value.replaceAll('"', r'\"');
  return '"$literal"';
}

String literalOfList(List<dynamic> value) {
  final items = value.map(literalOf).join(",");
  return "[$items]";
}

String literalOfSet(Set<dynamic> value) {
  final items = value.map(literalOf).join(",");
  return "{$items}";
}

String literalOfMap(Map<dynamic, dynamic> value) {
  final entries = [
    for (final MapEntry(:key, :value) in value.entries)
      "${literalOf(key)}:${literalOf(value)}",
  ].join(",");
  return "{$entries}";
}

bool canConvertToRecord(Map<dynamic, dynamic> value) {
  return value.keys.every(
      (key) => key is String && validDartIdentifierPattern.hasMatch(key));
}

String _literalOfRecordField(dynamic value) {
  assert(value is String);
  assert(validDartIdentifierPattern.hasMatch(value));
  final recased = (value as String).camelCase;
  return reservedDartKeywords.contains(recased) ? "\$$recased" : recased;
}

String literalOfRecord(Map<dynamic, dynamic> value) {
  assert(canConvertToRecord(value));
  final entries = [
    for (final MapEntry(:key, :value) in value.entries)
      "${_literalOfRecordField(key)}:${literalOf(value)}"
  ].join(",");
  return "($entries)";
}

import 'package:embed/src/primitives/primitives.dart';
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

final _validRecordFieldNamePattern = RegExp(r"^[a-zA-Z]\w*$");

bool isValidRecordFieldName(String value) {
  return _validRecordFieldNamePattern.hasMatch(value);
}

bool canConvertToRecord(Map<dynamic, dynamic> value) {
  return value.keys
      .every((key) => key is String && isValidRecordFieldName(key));
}

String literalOfRecord(Map<dynamic, dynamic> value) {
  assert(canConvertToRecord(value));
  final entries = [
    for (final MapEntry(:key, :value) in value.entries)
      "${(key as String).camelCase}:${literalOf(value)}"
  ].join(",");
  return "($entries)";
}

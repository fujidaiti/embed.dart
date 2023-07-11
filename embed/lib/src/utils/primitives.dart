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
      "$key:${literalOf(value)}"
  ].join(",");
  return "($entries)";
}

String literalOf(dynamic value) {
  return switch (value) {
    null => literalOfNull(),
    bool value => literalOfBool(value),
    int value => literalOfInt(value),
    double value => literalOfDouble(value),
    String value => literalOfString(value),
    Map value when canConvertToRecord(value) => literalOfRecord(value),
    Map value => literalOfMap(value),
    Set value => literalOfSet(value),
    List value => literalOfList(value),
    _ => throw ArgumentError.value(
        value, "value", "'${value.runtimeType}' type is not supported")
  };
}

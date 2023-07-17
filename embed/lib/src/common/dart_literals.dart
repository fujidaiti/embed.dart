import 'package:embed/src/common/dart_identifier.dart';

sealed class DartLiteral<T> {
  final T value;

  const DartLiteral(this.value);
}

class NullLiteral extends DartLiteral<void> {
  const NullLiteral() : super(null);

  @override
  String toString() => "null";
}

class IntLiteral extends DartLiteral<int> {
  const IntLiteral(super.value);

  @override
  String toString() => "$value";
}

class DoubleLiteral extends DartLiteral<double> {
  const DoubleLiteral(super.value);

  @override
  String toString() => "$value";
}

class BoolLiteral extends DartLiteral<bool> {
  const BoolLiteral(super.value);

  @override
  String toString() => "$value";
}

class StringLiteral extends DartLiteral<String> {
  const StringLiteral(super.value);

  @override
  String toString() {
    final literal = value.replaceAll('"', r'\"');
    return '"$literal"';
  }
}

class ListLiteral extends DartLiteral<List<DartLiteral>> {
  const ListLiteral(super.value);

  @override
  String toString() => "[${value.join(",")}]";
}

class SetLiteral extends DartLiteral<Set<DartLiteral>> {
  const SetLiteral(super.value);

  @override
  String toString() => "{${value.join(",")}}";
}

class MapLiteral extends DartLiteral<Map<DartLiteral, DartLiteral>> {
  const MapLiteral(super.value);

  @override
  String toString() {
    final entries = [
      for (final MapEntry(:key, :value) in value.entries) "$key:$value",
    ].join(",");
    return "{$entries}";
  }
}

class UnnamedRecordLiteral extends DartLiteral<List<DartLiteral>> {
  const UnnamedRecordLiteral(super.value);

  @override
  String toString() => "(${value.join(",")})";
}

class NamedRecordLiteral extends DartLiteral<Map<DartIdentifier, DartLiteral>> {
  const NamedRecordLiteral(super.value);

  @override
  String toString() {
    final entries =
        value.entries.map((field) => "${field.key}:${field.value}").join(",");
    return "($entries)";
  }
}

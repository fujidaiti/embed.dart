import 'package:collection/collection.dart';
import 'package:embed/src/literal/dart_identifier.dart';

abstract class DartLiteral<T> {
  final T value;

  const DartLiteral(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DartLiteral &&
          runtimeType == other.runtimeType &&
          value == other.value);

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

abstract class CollectionLiteral<T> extends DartLiteral<T> {
  const CollectionLiteral(super.value);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionLiteral &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(value, other.value));
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

class HexdecimalIntLiteral extends DartLiteral<int> {
  const HexdecimalIntLiteral(super.value);

  @override
  String toString() {
    final hexCode = value.toRadixString(16).padLeft(8, "0");
    return "0x$hexCode";
  }
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

class ListLiteral extends CollectionLiteral<List<DartLiteral>> {
  const ListLiteral(super.value);

  @override
  String toString() => "[${value.join(",")}]";
}

class SetLiteral extends CollectionLiteral<Set<DartLiteral>> {
  const SetLiteral(super.value);

  @override
  String toString() => "{${value.join(",")}}";
}

class MapLiteral extends CollectionLiteral<Map<DartLiteral, DartLiteral>> {
  const MapLiteral(super.value);

  @override
  String toString() {
    final entries = [
      for (final MapEntry(:key, :value) in value.entries) "$key:$value",
    ].join(",");
    return "{$entries}";
  }
}

class UnnamedRecordLiteral extends CollectionLiteral<List<DartLiteral>> {
  const UnnamedRecordLiteral(super.value);

  @override
  String toString() => "(${value.join(",")})";
}

class NamedRecordLiteral
    extends CollectionLiteral<Map<DartIdentifier, DartLiteral>> {
  const NamedRecordLiteral(super.value);

  @override
  String toString() {
    final entries =
        value.entries.map((field) => "${field.key}:${field.value}").join(",");
    return "($entries)";
  }
}

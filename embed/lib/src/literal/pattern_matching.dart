import 'package:embed/src/common/errors.dart';
import 'package:embed/src/literal/dart_identifier.dart';
import 'package:embed/src/literal/dart_literals.dart';
import 'package:embed/src/literal/type_constraints.dart';
import 'package:embed/src/utils.dart';
import 'package:toml/toml.dart';

/// Given a [value] and a [expectedType] that constraints the shape
/// of the [value], returns a portion of the [value] that matches the
/// [expectedType].
DartLiteral match(Object? value, TypeConstraint expectedType) {
  Never typeMismatchError({required String hint}) => throw UsageError(
        "Expected a value of type '$expectedType', "
        "but found '$value' of type '${value.runtimeType}'.\n"
        'Hint: $hint',
      );

  switch ((value, expectedType)) {
    case (null, TypeConstraint(isNullable: true)):
      return const NullLiteral();
    case (final int value, IntType _ || AnyType _):
      return IntLiteral(value);
    case (final int value, DoubleType _):
      return DoubleLiteral(value.toDouble());
    case (final int value, BoolType _) when value == 1:
      return const BoolLiteral(true);
    case (final int value, BoolType _) when value == 0:
      return const BoolLiteral(false);
    case (final double value, DoubleType _ || AnyType _):
      return DoubleLiteral(value);
    case (final double value, IntType _):
      return IntLiteral(value.round());
    case (final bool value, BoolType _ || AnyType _):
      return BoolLiteral(value);
    case (final bool value, IntType _):
      return IntLiteral(value ? 1 : 0);
    case (final String value, StringType _ || AnyType _):
      return StringLiteral(value);
    case (final String value, IntType _) when value.startsWith('0x'):
      return HexdecimalIntLiteral(int.parse(value));
    case (final TomlDateTime value, StringType _ || AnyType _):
      return StringLiteral(value.toString());

    case (final List values, final ListType expected):
      return ListLiteral([
        for (final item in values) match(item, expected.itemType),
      ]);

    case (final List values, final SetType expected):
      return SetLiteral({
        for (final item in values) match(item, expected.itemType),
      });

    case (final List values, UnnamedRecordType(fields: final fields)):
      if (values.length < fields.length) {
        throw typeMismatchError(
          hint: 'Expected at least ${fields.length} values for '
              'the positional fields, but only ${values.length} was found.',
        );
      }
      return UnnamedRecordLiteral([
        for (final (value, type) in zip(values, fields)) match(value, type)
      ]);

    case (final List values, final AnyType any):
      return ListLiteral([for (final value in values) match(value, any)]);

    case (final Map values, final MapType expected):
      return MapLiteral({
        for (final MapEntry(:key, :value) in values.entries)
          match(key, expected.keyType): match(value, expected.valueType)
      });

    case (final Map values, final NamedRecordType expected):
      return NamedRecordLiteral({
        for (final field in expected.fields.entries)
          if (values.containsKey(field.key.string))
            field.key: match(values[field.key.string], field.value)
          else if (field.value.isNullable)
            field.key: const NullLiteral()
          else
            DartIdentifier('_'): typeMismatchError(
                hint: "The given value doesn't contain a key-value pair "
                    "for the field '${field.key}' of type '${field.value}'.")
      });

    case (final Map values, final AnyType any) when _canBeNamedRecord(values):
      return NamedRecordLiteral({
        for (final MapEntry(:key, :value) in values.entries)
          DartIdentifier(key): match(value, any)
      });

    case (final Map values, final AnyType any):
      return MapLiteral({
        for (final MapEntry(:key, :value) in values.entries)
          match(key, any): match(value, any)
      });

    default:
      typeMismatchError(
        hint: "The given value doesn't satisfy the type constraint, "
            'or the given type constraint is not supported.',
      );
  }
}

bool _canBeNamedRecord(Map values) => values.keys.every(
      (key) => key is String && isValidDartIdentifier(key),
    );

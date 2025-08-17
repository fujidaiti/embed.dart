import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart' as t;
import 'package:embed/src/common/errors.dart';
import 'package:embed/src/literal/dart_identifier.dart';
import 'package:meta/meta.dart';

sealed class TypeConstraint {
  @visibleForTesting
  const TypeConstraint({
    required this.isNullable,
    required this.displayString,
  });

  factory TypeConstraint.from(t.DartType type) {
    switch (type) {
      case t.DynamicType _ || t.InvalidType _:
        return const DynamicType();
      case final t.RecordType type when type.namedFields.isEmpty:
        return UnnamedRecordType.from(type);
      case final t.RecordType type when type.positionalFields.isEmpty:
        return NamedRecordType.from(type);
      case final t.InterfaceType type:
        if (type.isDartCoreObject) {
          return ObjectType.from(type);
        } else if (type.isDartCoreInt) {
          return IntType.from(type);
        } else if (type.isDartCoreDouble) {
          return DoubleType.from(type);
        } else if (type.isDartCoreBool) {
          return BoolType.from(type);
        } else if (type.isDartCoreString) {
          return StringType.from(type);
        } else if (type.isDartCoreList) {
          return ListType.from(type);
        } else if (type.isDartCoreSet) {
          return SetType.from(type);
        } else if (type.isDartCoreMap) {
          return MapType.from(type);
        }
    }

    throw UsageError("'$type' type is not supported");
  }

  final bool isNullable;
  final String displayString;

  @override
  String toString() => displayString;
}

class IntType extends TypeConstraint {
  @visibleForTesting
  const IntType({
    required super.isNullable,
    required super.displayString,
  });

  factory IntType.from(t.InterfaceType type) {
    assert(type.isDartCoreInt);
    return IntType(
      isNullable: type.isNullable,
      displayString: type.displayString,
    );
  }
}

class DoubleType extends TypeConstraint {
  @visibleForTesting
  const DoubleType({
    required super.isNullable,
    required super.displayString,
  });

  factory DoubleType.from(t.InterfaceType type) {
    assert(type.isDartCoreDouble);
    return DoubleType(
      isNullable: type.isNullable,
      displayString: type.displayString,
    );
  }
}

class BoolType extends TypeConstraint {
  @visibleForTesting
  const BoolType({
    required super.isNullable,
    required super.displayString,
  });

  factory BoolType.from(t.InterfaceType type) {
    assert(type.isDartCoreBool);
    return BoolType(
      isNullable: type.isNullable,
      displayString: type.displayString,
    );
  }
}

class StringType extends TypeConstraint {
  @visibleForTesting
  const StringType({
    required super.isNullable,
    required super.displayString,
  });

  factory StringType.from(t.InterfaceType type) {
    assert(type.isDartCoreString);
    return StringType(
      isNullable: type.isNullable,
      displayString: type.displayString,
    );
  }
}

class ListType extends TypeConstraint {
  @visibleForTesting
  const ListType({
    required super.isNullable,
    required super.displayString,
    required this.itemType,
  });

  factory ListType.from(t.InterfaceType type) {
    assert(type.isDartCoreList && type.typeArguments.length == 1);
    return ListType(
      isNullable: type.isNullable,
      displayString: type.displayString,
      itemType: TypeConstraint.from(type.typeArguments[0]),
    );
  }

  final TypeConstraint itemType;
}

class SetType extends TypeConstraint {
  @visibleForTesting
  const SetType({
    required super.isNullable,
    required super.displayString,
    required this.itemType,
  });

  factory SetType.from(t.InterfaceType type) {
    assert(type.isDartCoreSet && type.typeArguments.length == 1);
    return SetType(
      isNullable: type.isNullable,
      displayString: type.displayString,
      itemType: TypeConstraint.from(type.typeArguments[0]),
    );
  }

  final TypeConstraint itemType;
}

class MapType extends TypeConstraint {
  @visibleForTesting
  const MapType({
    required super.isNullable,
    required super.displayString,
    required this.keyType,
    required this.valueType,
  });

  factory MapType.from(t.InterfaceType type) {
    assert(type.isDartCoreMap && type.typeArguments.length == 2);
    return MapType(
      isNullable: type.isNullable,
      displayString: type.displayString,
      keyType: TypeConstraint.from(type.typeArguments[0]),
      valueType: TypeConstraint.from(type.typeArguments[1]),
    );
  }

  final TypeConstraint keyType;
  final TypeConstraint valueType;
}

class UnnamedRecordType extends TypeConstraint {
  @visibleForTesting
  const UnnamedRecordType({
    required super.isNullable,
    required super.displayString,
    required this.fields,
  });

  factory UnnamedRecordType.from(t.RecordType type) {
    assert(type.namedFields.isEmpty);
    return UnnamedRecordType(
      isNullable: type.isNullable,
      displayString: type.displayString,
      fields: [
        for (final field in type.positionalFields)
          TypeConstraint.from(field.type)
      ],
    );
  }

  final List<TypeConstraint> fields;
}

class NamedRecordType extends TypeConstraint {
  @visibleForTesting
  const NamedRecordType({
    required super.displayString,
    required super.isNullable,
    required this.fields,
  });

  factory NamedRecordType.from(t.RecordType type) {
    assert(type.positionalFields.isEmpty);
    return NamedRecordType(
      displayString: type.displayString,
      isNullable: type.isNullable,
      fields: {
        for (final field in type.namedFields)
          DartIdentifier(field.name): TypeConstraint.from(field.type)
      },
    );
  }

  final Map<DartIdentifier, TypeConstraint> fields;
}

abstract class AnyType extends TypeConstraint {
  const AnyType({
    required super.isNullable,
    required super.displayString,
  });
}

class ObjectType extends AnyType {
  @visibleForTesting
  const ObjectType({
    required super.isNullable,
    required super.displayString,
  });

  factory ObjectType.from(t.InterfaceType type) {
    assert(type.isDartCoreObject);
    return ObjectType(
      isNullable: type.isNullable,
      displayString: type.displayString,
    );
  }
}

class DynamicType extends AnyType {
  const DynamicType()
      : super(
          isNullable: true,
          displayString: 'dynamic',
        );
}

extension _IsNullable on t.DartType {
  bool get isNullable => switch (nullabilitySuffix) {
        NullabilitySuffix.question => true,
        NullabilitySuffix.none => false,
        // TODO: What is the "star"!?
        NullabilitySuffix.star => throw ShouldNeverBeHappenError(),
      };

  String get displayString => getDisplayString();
}

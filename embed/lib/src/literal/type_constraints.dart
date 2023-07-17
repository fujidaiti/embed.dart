import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart' as t;
import 'package:embed/src/common/errors.dart';

sealed class TypeConstraint {
  TypeConstraint();

  abstract final t.DartType src;

  factory TypeConstraint.from(t.DartType type) {
    switch (type) {
      case t.DynamicType _ || t.InvalidType _:
        return DynamicType(type);
      case t.RecordType type when type.namedFields.isEmpty:
        return UnnamedRecordType(type);
      case t.RecordType type when type.positionalFields.isEmpty:
        return NamedRecordType(type);
      case t.InterfaceType type:
        if (type.isDartCoreObject) {
          return ObjectType(type);
        } else if (type.isDartCoreInt) {
          return IntType(type);
        } else if (type.isDartCoreDouble) {
          return DoubleType(type);
        } else if (type.isDartCoreBool) {
          return BoolType(type);
        } else if (type.isDartCoreString) {
          return StringType(type);
        } else if (type.isDartCoreList) {
          return ListType(type);
        } else if (type.isDartCoreSet) {
          return SetType(type);
        } else if (type.isDartCoreMap) {
          return MapType(type);
        }
    }

    throw UsageError("'$type' type is not supported");
  }

  bool get isNullable => switch (src.nullabilitySuffix) {
        NullabilitySuffix.question => true,
        NullabilitySuffix.none => false,
        // TODO: What is the "star"!?
        NullabilitySuffix.star => throw ShouldNeverBeHappenError(),
      };

  @override
  String toString() => src.getDisplayString(withNullability: true);
}

class IntType extends TypeConstraint {
  IntType(this.src) : assert(src.isDartCoreInt);

  @override
  final t.DartType src;
}

class DoubleType extends TypeConstraint {
  DoubleType(this.src) : assert(src.isDartCoreDouble);

  @override
  final t.DartType src;
}

class BoolType extends TypeConstraint {
  BoolType(this.src) : assert(src.isDartCoreBool);

  @override
  final t.DartType src;
}

class StringType extends TypeConstraint {
  StringType(this.src) : assert(src.isDartCoreBool);

  @override
  final t.DartType src;
}

class ListType extends TypeConstraint {
  ListType(this.src)
      : assert(src.isDartCoreList && src.typeArguments.length == 1);

  @override
  final t.InterfaceType src;

  late final TypeConstraint itemType =
      TypeConstraint.from(src.typeArguments[0]);
}

class SetType extends TypeConstraint {
  SetType(this.src)
      : assert(src.isDartCoreSet && src.typeArguments.length == 1);

  @override
  final t.InterfaceType src;

  late final TypeConstraint itemType =
      TypeConstraint.from(src.typeArguments[0]);
}

class MapType extends TypeConstraint {
  MapType(this.src)
      : assert(src.isDartCoreMap && src.typeArguments.length == 2);

  @override
  final t.InterfaceType src;

  late final TypeConstraint keyType = TypeConstraint.from(src.typeArguments[0]);

  late final TypeConstraint valueType =
      TypeConstraint.from(src.typeArguments[1]);
}

class UnnamedRecordType extends TypeConstraint {
  UnnamedRecordType(this.src) : assert(src.namedFields.isEmpty);

  @override
  final t.RecordType src;

  late final List<TypeConstraint> fields = src.positionalFields
      .map((field) => TypeConstraint.from(field.type))
      .toList(growable: false);
}

class NamedRecordType extends TypeConstraint {
  NamedRecordType(this.src) : assert(src.positionalFields.isEmpty);

  @override
  final t.RecordType src;

  late final Map<String, TypeConstraint> fields = {
    for (final field in src.namedFields)
      field.name: TypeConstraint.from(field.type)
  };
}

abstract class AnyType extends TypeConstraint {}

class ObjectType extends AnyType {
  ObjectType(this.src) : assert(src.isDartCoreObject);

  @override
  final t.InterfaceType src;
}

class DynamicType extends AnyType {
  DynamicType(this.src) : assert(src is t.DynamicType || src is t.InvalidType);

  @override
  final t.DartType src;

  @override
  bool get isNullable => true;

  @override
  String toString() => "dynamic";
}

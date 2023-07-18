import 'package:embed/src/common/errors.dart';
import 'package:embed/src/literal/dart_identifier.dart';
import 'package:embed/src/literal/dart_literals.dart';
import 'package:embed/src/literal/pattern_matching.dart';
import 'package:embed/src/literal/type_constraints.dart';
import 'package:test/test.dart';
import 'package:toml/toml.dart';

void main() {
  group("match", () {
    test(
        "should return a null literal if the given value "
        "is null and the type is constrained to be nullable", () {
      final result = match(null, const DynamicType());
      expect(result, const NullLiteral());
    });

    test(
        "should return a int literal if the given value "
        "is an integer and the type is constrained to be int", () {
      final constraint = IntType(isNullable: false, displayString: "int");
      final result = match(0, constraint);
      expect(result, const IntLiteral(0));
    });

    test(
        "should return a double literal if the given value "
        "is a float value and the type is constrained to be double", () {
      final constraint = DoubleType(isNullable: false, displayString: "double");
      final result = match(0.0, constraint);
      expect(result, const DoubleLiteral(0.0));
    });

    test(
        "should return a bool literal if the given value "
        "is a boolean value and the type is constrained to be bool", () {
      final constraint = BoolType(isNullable: false, displayString: "bool");
      final result = match(true, constraint);
      expect(result, const BoolLiteral(true));
    });

    test(
        "should return a string literal if the given value "
        "is a string and the type is constrained to be String", () {
      final constraint = StringType(isNullable: false, displayString: "String");
      final result = match("text", constraint);
      expect(result, const StringLiteral("text"));
    });

    test(
        "should return a string literal if the given value "
        "is a toml's datetime and the type is constrained to be String", () {
      final constraint = StringType(isNullable: false, displayString: "String");
      final value = TomlLocalDate(TomlFullDate(2023, 7, 18));
      final result = match(value, constraint);
      expect(result, const StringLiteral("2023-07-18"));
    });

    test(
        "should return a list literal if the given value "
        "is an array of values and the type is constrained to be List", () {
      final constraint = ListType(
        isNullable: false,
        displayString: "List<int>",
        itemType: IntType(
          isNullable: false,
          displayString: "int",
        ),
      );
      final result = match([0], constraint);
      expect(result, const ListLiteral([IntLiteral(0)]));
    });

    test(
        "should return a set literal if the given value "
        "is an array of values and the type is constrained to be Set", () {
      final constraint = SetType(
        isNullable: false,
        displayString: "Set<int>",
        itemType: IntType(
          isNullable: false,
          displayString: "int",
        ),
      );
      final result = match([0], constraint);
      expect(result, SetLiteral({IntLiteral(0)}));
    });

    test(
        "should return an unnamed record if the given value "
        "is an array of values and the type is constrained to be "
        "Record which has only positional fields", () {
      final constraint = UnnamedRecordType(
        isNullable: false,
        displayString: "(int,)",
        fields: [
          IntType(
            isNullable: false,
            displayString: "int",
          ),
        ],
      );
      final result = match([0], constraint);
      expect(result, UnnamedRecordLiteral([IntLiteral(0)]));
    });

    test(
        "should return a list literal if the given value "
        "is an array of values and no type constraint is specified", () {
      final result = match([0], const DynamicType());
      expect(result, ListLiteral([IntLiteral(0)]));
    });

    test(
        "should return a map literal if the given value is "
        "a key-value data and type is constrained to Map", () {
      final constraint = MapType(
        isNullable: false,
        displayString: "Map<String, int>",
        keyType: StringType(
          isNullable: false,
          displayString: "String",
        ),
        valueType: IntType(
          isNullable: false,
          displayString: "int",
        ),
      );

      final result = match({'a': 0}, constraint);
      expect(result, MapLiteral({StringLiteral("a"): IntLiteral(0)}));
    });

    test(
        "should return a record literal if the given value "
        "is a key-value data and the type is constrained to be "
        "Record which has only named fields", () {
      final constraint = NamedRecordType(
        isNullable: false,
        displayString: "({int a})",
        fields: {
          DartIdentifier("a"): IntType(
            isNullable: false,
            displayString: "int",
          ),
        },
      );

      expect(
        match({"a": 0}, constraint),
        NamedRecordLiteral({
          DartIdentifier("a"): IntLiteral(0),
        }),
      );
    });

    test(
        "should return a map literal if the given value is "
        "a key-value data that can be interpretable as a record, "
        "and no type constriant is specified", () {
      expect(
        match({"a": null}, const DynamicType()),
        NamedRecordLiteral({DartIdentifier("a"): const NullLiteral()}),
      );
    });

    test(
        "should return a map literal if the given value is "
        "a key-value data that can't be interpretable as a record, "
        "and no type constriant is specified", () {
      expect(
        match({0: null}, const DynamicType()),
        MapLiteral({IntLiteral(0): const NullLiteral()}),
      );
    });

    test(
        "should throw an error if the given value is "
        "an array of values and the type constrained to be Record "
        "which has only positional fields, but the length of the array is less than"
        "the number of the record fields", () {
      final constraint = UnnamedRecordType(
        isNullable: false,
        displayString: "(int,)",
        fields: [
          IntType(
            isNullable: false,
            displayString: "int",
          ),
        ],
      );
      expect(
        () => match([], constraint),
        throwsA(isA<UsageError>().having(
          (err) => err.message,
          "message",
          "Expected a value of type '(int,)', "
              "but found '[]' of type 'List<dynamic>'.\n"
              "Hint: Expected at least 1 values for the positional fields, "
              "but only 0 was found.",
        )),
      );
    });

    test(
        "should throw an error if the given value is "
        "a key-value data and the type is constrained to be Record "
        "which has only named fields, but some fields names of the record "
        "are missing in the data as keys", () {
      final constraint = NamedRecordType(
        isNullable: false,
        displayString: "({int a})",
        fields: {
          DartIdentifier("a"): IntType(
            isNullable: false,
            displayString: "int",
          ),
        },
      );

      expect(
        () => match({}, constraint),
        throwsA(isA<UsageError>().having(
          (err) => err.message,
          "message",
          "Expected a value of type '({int a})', "
              "but found '{}' of type '_Map<dynamic, dynamic>'.\n"
              "Hint: The given value doesn't contain a key-value pair "
              "for the field 'a' of type 'int'.",
        )),
      );
    });

    test(
        "should throw an error if an unsupported combination of "
        "a value and a type constraint is given", () {
      final constraint = DoubleType(
        isNullable: false,
        displayString: "double",
      );
      expect(
        () => match(0, constraint),
        throwsA(isA<UsageError>().having(
          (err) => err.message,
          "message",
          "Expected a value of type 'double', "
              "but found '0' of type 'int'.\n"
              "Hint: The given value doesn't satisfy the type constraint, "
              "or the given type constraint is not supported.",
        )),
      );
    });
  });
}

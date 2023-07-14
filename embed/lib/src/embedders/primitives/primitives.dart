import 'package:embed/src/common/errors.dart';
import 'package:embed/src/embedders/primitives/dart_primitives.dart';
import 'package:embed/src/embedders/primitives/toml_primitives.dart' as toml;
import 'package:toml/toml.dart';

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
    TomlDateTime value => toml.literalOfDateTime(value),
    _ => throw UsageError("'${value.runtimeType}' type is not supported")
  };
}

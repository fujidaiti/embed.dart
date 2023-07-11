import 'package:embed/src/primitives/dart_primitives.dart';
import 'package:toml/toml.dart';

String literalOfDateTime(TomlDateTime value) {
  return literalOfString(value.toString());
}

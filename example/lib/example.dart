import 'package:embed_annotation/embed_annotation.dart';

// DO NOT FORGET THIS LINE!
part 'example.g.dart';

// Use [EmbedStr] to embed the file content as a string literal.
// You can specify the path as relative to the source file.
@EmbedStr("data/text_to_embed.txt")
const embeddedText = _$embeddedText;

// Any text content can be embedded as a string literal.
@EmbedStr("data/json_to_embed.json")
const embeddedJsonString = _$embeddedJsonString;

// Use [EmbedLiteral] to embed a structured data as a dart object.
// Currently, [EmbedLiteral] supports JSON, YAML and TOML files.
@EmbedLiteral("data/json_to_embed.json")
const embeddedJson = _$embeddedJson;

// The code generator attempts to represent map-like data as records from Dart 3
// rather than [Map]s whenever possible.
@EmbedLiteral("data/toml_to_embed.toml")
const embeddedToml = _$embeddedToml;

// Absolute paths are treated as relative to the package root.
// For example, the following is equivalent to `EmbedLiteral("../pubspec.yaml")`.
@EmbedLiteral("/pubspec.yaml")
const embeddedYaml = _$embeddedYaml;

void main() {
  // When a map-like data is converted to a record, and it contains
  // reserved Dart language keywords such as 'if' and 'case' as its field names,
  // the code generator adds a '$' sign to the beginning of the field names
  // like '$if' and '$case'. In addition, field names are automatically converted
  // to lowerCamelCase according to Dart's recommended style.
  double _ = embeddedToml.database.tempTargets.$case;
}

import 'package:embed/src/literal/preprocessing.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:test/test.dart';

void main() {
  test("Recase", () {
    final preprocessing = Preprocessing([
      Preprocessor.recase,
    ]);
    expect(
      preprocessing.applyTo({"snake_case": null}),
      {"snakeCase": null},
    );
  });

  test("Escape reserved keywords", () {
    final preprocessing = Preprocessing([
      Preprocessor.escapeReservedKeywords,
    ]);
    expect(
      preprocessing.applyTo({"final": null}),
      {r"$final": null},
    );
  });

  test("Combination", () {
    final preprocessing = Preprocessing([
      Preprocessor.recase,
      Preprocessor.escapeReservedKeywords,
    ]);
    expect(
      preprocessing.applyTo({"Final": null}),
      {r"$final": null},
    );
  });

  test("Replace", () {
    final preprocessing = Preprocessing([
      Preprocessor.replace("#", "0x"),
    ]);
    expect(
      preprocessing.applyTo({null: "#ff0000"}),
      {null: "0xff0000"},
    );
  });
}

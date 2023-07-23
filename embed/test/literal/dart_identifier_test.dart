import 'package:embed/src/literal/dart_identifier.dart';
import 'package:test/test.dart';

const validIdentifiers = [r"$", r"$var", r"_"];
const invalidIdentifiers = ["0", "@", "0a"];

void main() {
  group("isValidDartIdentifier:", () {
    for (final identifier in validIdentifiers) {
      test("'$identifier' is a valid identifier", () {
        expect(
          isValidDartIdentifier(identifier),
          true,
          reason: "'$identifier' was unexpectedly determined to be invalid.",
        );
      });
    }

    for (final identifier in invalidIdentifiers) {
      test("'$identifier' is an invalid identifier", () {
        expect(
          isValidDartIdentifier(identifier),
          false,
          reason: "'$identifier' was unexpectedly determined to be valid.",
        );
      });
    }
  });
}

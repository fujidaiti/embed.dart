# CHANGELOG

## 1.7.0

- Regenerate the code when the content of an embedded file changes. See [this guide][#53-guide] for more details. ([#53])
- Fix embedded file paths being resolved against the workspace root directory
  instead of the package root directory in a pub workspace ([#55])

[#53]: https://github.com/fujidaiti/embed.dart/pull/53
[#53-guide]: https://github.com/fujidaiti/embed.dart/blob/master/embed/README.md#i-edited-my-json-file-to-embed-but-the-generated-code-doesnt-update-even-when-i-run-build_runner-again
[#55]: https://github.com/fujidaiti/embed.dart/issues/55

## 1.6.7

- Support analyzer v14

## 1.6.6

- Support analyzer v13

## 1.6.5

- Support analyzer v12

## 1.6.4

- Support analyzer v10 ([#46](https://github.com/fujidaiti/embed.dart/pull/46))

## 1.6.3

- Support analyzer v9 ([#42](https://github.com/fujidaiti/embed.dart/pull/42))

## 1.6.2

- Support `toml` 0.17.x ([#38](https://github.com/fujidaiti/embed.dart/pull/38) by @FrankenApps)

## 1.6.1

- Require Dart SDK version 3.6.0 or higher ([#37](https://github.com/fujidaiti/embed.dart/pull/37))
- Allow build `>=3.0.0 <5.0.0` and source_gen `>=3.1.0 <5.0.0` ([#36](https://github.com/fujidaiti/embed.dart/pull/36) by @FrankenApps)

## 1.6.0

- Allow analyzer `>=7.4.0 <9.0.0`. ([#32](https://github.com/fujidaiti/embed.dart/pull/32) by @FrankenApps)
- Require source_gen `>=3.1.0`. ([#33](https://github.com/fujidaiti/embed.dart/pull/33) by @FrankenApps)

## 1.5.0

- Require `analyzer` 7.4.0 or higher to migrate to [the analyzer's new element models](https://github.com/dart-lang/sdk/blob/main/pkg/analyzer/doc/element_model_migration_guide.md) ([#27](https://github.com/fujidaiti/embed.dart/pull/27) by @FrankenApps, [#30](https://github.com/fujidaiti/embed.dart/pull/30))

## 1.4.1

- Upgrade outdated packages (#25)

## 1.4.0

- Upgrade dependencies (#22)

## 1.3.1

- fix(embed): escape dollar symbol of JSON string literal (#21 by @Jumpaku)

## 1.3.0

- Update `toml` dependency to 0.15.0 (#17 by @bramp)
- Required Dart SDK version is now 3.2 or higher

## 1.2.0

- New feature: embedding binary contents (#13 by @NicolaVerbeeck)

## 1.1.0

- New feature: pattern matching (#4)
- New feature: preprocessing
- Improved error messages

## 1.0.0

Initial release.

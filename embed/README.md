# embed.dart

Code generation for embedding external content in Dart code

## Motivation

## Index

## Installation

Run the following command:

For a Flutter project:

```shell
flutter pub add embed_annotation dev:embed dev:build_runner
```

For a Dart project:

```shell
dart pub add embed_annotation dev:embed dev:build_runner
```

This command installs three packages:

- embed: the code generator
- embed_annotation: a package exposing annotations for embed
- build_runner: a tool to run code generators, published by the Dart team

## Quickstart

Here's an example of embedding the content of the `pubspec.yaml` in the Dart code as an object:

```dart
// This file is 'main.dart'

// Import annotations
import 'package:embed_annotation/embed_annotation.dart';

// Like other code generation packages, you need to add this line
part 'main.g.dart';

// Create an annotation specifing the location of a content file to embed
@EmbedLiteral("../pubspec.yaml")
const pubspec = _$pubspec;
```

Then, run the code generator:

```shell
dart run build_runner build
```

If your are creating a Flutter project, you can also run the generator by:

```
flutter pub build_runner build
```

Finally, you should see the  `main.g.dart` is generated in the same directory as `main.dart`.

```dart
// This is 'main.g.dart'

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// EmbedGenerator
// **************************************************************************

const _$pubspec = (
  name: "example_app",
  publishTo: "none",
  environment: (sdk: "^3.0.5"),
  dependencies: (embedAnnotation: (path: "../embed_annotation")),
  devDependencies: (
    buildRunner: "^2.4.6",
    lints: "^2.0.0",
    embed: (path: "../embed")
  ),
  dependencyOverrides: (embedAnnotation: (path: "../embed_annotation"))
);
```

You can see the content of the `pubspec.yaml` is embedded as a [record object](https://dart.dev/language/records) in the generated file. Let's print your package name to the console:

```dart
print(pubspec.name); // This should display "example_app"
```

After modifying the original file, the `pubspec.yaml` in this case, you need to run the code generator again to update the embedded content. It is recommended deleting the cache before running the `build_runner` for avoiding some code generation problem (see for the [troubleshooting guide](#troubleshooting-guide) more information), as follows:

```shell
flutter pub run build_runner clean
```



## How to use

Currently, there are 2 kinds of embedding methods:

- [Embed a text content as a String literal](#embed-a-text-content-as-a-string-literal)
- [Embed a structured data as a Dart object](#embed-a-structured-data-as-a-dart-object)



### Embed a text content as a String literal

### Embed a structured data as a Dart object



## Troubleshooting Guide

### I edited my json file to be embeded, but the embedded value does't be updated even if reruning build_runner

Clear the cache and run `build_runner` again.

```shell
dart pub run build_runner clean && dart pub run build_runner build
```

If you are still having the problem, try this:

```shell
flutter clean && dart pub run build_runner build
```


## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<br/>

## Thanks

* [Best-README-Template](https://github.com/othneildrew/Best-README-Template/tree/master) by [@othneildrew](https://github.com/othneildrew)

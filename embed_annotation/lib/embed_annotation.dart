/// Base class for the all annotation classes that configures how content is embedded.
///
/// Use the one of the following subclasses to configure how content should be embedded.
///
/// * [EmbedStr] : For embedding a text content as a string literal.
/// * [EmbedBinary] : For embedding a binary data as an integer list or a base64 string.
/// * [EmbedLiteral] : For embedding a structured data as a dart object.
///
/// Only top level elements can be annotated with these annotations.
sealed class Embed {
  // Make this constructor private to prevent [Embed]
  // from being extended from the outside of the package.
  //
  // In fact, 'sealed' classes are implicitly 'abstract',
  // so no one can extend [Embed] outside of this file.
  // But this rule does not seem to apply when it comes to
  // creating annotations, i.e. `@Embed("/path")` is always valid,
  // even if it is done outside of this package.
  const Embed._(this.path);

  /// The path to the content file to be embedded.
  ///
  /// If [path] is a relative path, it is treated as relative to
  /// the parent directory of the source file where the annotation is defined.
  /// Otherwise, if it is an absolute path, it is treated as relative to
  /// the package root directory.
  ///
  /// For example, the following annotation tells the code generator that
  /// the specified content file exists in `package_root/lib/file_to_embed.json`.
  ///
  /// ```dart
  /// // package_root/lib/example.dart
  /// @EmbedStr('../pubspec.yaml')
  /// const pubspec = _$pubspec;
  /// ```
  ///
  /// Using the absolute path, the above example can be rewritten as follows:
  ///
  /// ```dart
  /// @EmbedStr('/pubspec.yaml')
  /// const pubspec = _$pubspec;
  /// ```
  final String path;
}

/// Annotation for embedding a text content as a string literal.
class EmbedStr extends Embed {
  /// Creates an annotation for embedding a text content as a string literal.
  ///
  /// By default, the text is embedded as a [raw string literal](https://dart.dev/language/built-in-types#strings).
  /// To embed it as a normal string literal, specify [raw] as `false`.
  const EmbedStr(super.path, {this.raw = true}) : super._();

  /// Specifies whether the generated string literal should be a raw string.
  final bool raw;
}

/// Annotation for embedding a structured data as a dart object.
///
/// Currently, JSON, YAML and TOML files are supported.
class EmbedLiteral extends Embed {
  /// Creates an annotation for embedding a structured data as a dart object.
  const EmbedLiteral(
    super.path, {
    this.preprocessors = const [
      Preprocessor.recase,
      Preprocessor.escapeReservedKeywords,
    ],
  }) : super._();

  /// Preprocessors applied to the parsed content.
  ///
  /// If the associated content is a structured data such as array
  /// or key-value data, the preprocessors will be applied recursively.
  final List<Preprocessor> preprocessors;
}

/// Annotation for embedding raw binary data as a `List<int>`.
class EmbedBinary extends Embed {
  /// Creates an annotation for embedding raw binary data. If [base64] is true,
  /// the binary data will be encoded as a base64 string, otherwise it will be
  /// encoded as a `List<int>`.
  const EmbedBinary(super.path, {this.base64 = false}) : super._();

  /// Specifies whether the generated literal should be a base64 string or a
  /// `List<int>`.
  final bool base64;
}

/// The base class of preprocessors.
sealed class Preprocessor {
  const Preprocessor._();

  /// {@macro embed_annotation.Recase}
  static const recase = Recase._();

  /// {@macro embed_annotation.EscapeReservedKeywords}
  static const escapeReservedKeywords = EscapeReservedKeywords._();

  /// Creates a preprocessor for text replacement.
  ///
  /// See [Replace] for more details.
  factory Preprocessor.replace(
    String pattern,
    String replacement, {
    bool onlyFirst = false,
  }) =>
      Replace(
        pattern,
        replacement,
        onlyFirst: onlyFirst,
      );
}

/// {@template embed_annotation.Recase}
/// A preprocessor that converts all string keys
/// stored in the given key-value data to camelCase.
///
/// e.g. `snake_case` and `kebab-case` will be converted
/// to `snakeCase` and `kebabCase`, respectively.
/// {@endtemplate}
class Recase extends Preprocessor {
  const Recase._() : super._();
}

/// {@template embed_annotation.EscapeReservedKeywords}
/// A preprocessor that adds a prefix '$' to all the reserved
/// Dart keywords used as keys in the given key-value data.
///
/// e.g. `if` and `case` will be converted to `$if` and `$case`, respectively.
/// {@endtemplate}
class EscapeReservedKeywords extends Preprocessor {
  const EscapeReservedKeywords._() : super._();
}

/// A preprocessor that replaces all substrings that
/// match [pattern] with [replacement].
class Replace extends Preprocessor {
  /// Creates a preprocessor for text replacement.
  const Replace(
    this.pattern,
    this.replacement, {
    this.onlyFirst = false,
  }) : super._();

  /// The pattern to match substrings to be replaced.
  final String pattern;

  /// The text to be inserted in place of the matched substrings.
  final String replacement;

  /// Indicate whether only the first matching substring
  /// should be replaced for each field.
  final bool onlyFirst;
}

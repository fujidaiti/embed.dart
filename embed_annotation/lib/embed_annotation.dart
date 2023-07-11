library embed_annotation;

/// Base class for the all annotation classes
/// that configures how content is embedded.
/// 
/// Use the one of the folowing subclasses to
/// configure how content should be embedded.
/// 
/// * [EmbedStr] : For embedding a text content as a string literal.
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
  /// Creates an annotatoin for embedding a text content as a string literal.
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
  const EmbedLiteral(super.path) : super._();
}

library embed_annotation;

sealed class Embed {
  const Embed._(this.path);
  final String path;
}

class EmbedStr extends Embed {
  const EmbedStr(super.path, {this.raw = true}) : super._();
  final bool raw;
}

class EmbedLiteral extends Embed {
  const EmbedLiteral(super.path) : super._();
}

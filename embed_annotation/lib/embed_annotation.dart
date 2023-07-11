library embed_annotation;

sealed class Embed {
  const Embed(this.path);
  final String path;
}

class EmbedStr extends Embed {
  const EmbedStr(super.path, {this.raw = true});
  final bool raw;
}

class EmbedLiteral extends Embed {
  const EmbedLiteral(super.path);
}

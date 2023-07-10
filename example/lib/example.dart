import 'package:embed_annotation/embed_annotation.dart';

part 'example.g.dart';

@Embed("json_to_embed.json")
const embedJson = embedJsonString;

import 'dart:io';

File resolveContent(String path) {
  final content = File(path);
  return switch (content.existsSync()) {
    true => content,
    false => throw ArgumentError.value(path, "path", "No such file exists"),
  };
}

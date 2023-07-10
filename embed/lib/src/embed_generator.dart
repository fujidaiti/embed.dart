import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:source_gen/source_gen.dart';

class EmbedGenerator extends GeneratorForAnnotation<Embed> {
  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final parent = "${Directory.current.path}/lib/";
    final path = "$parent/${annotation.read("path").stringValue}";
    final file = File(path);
    final content = await file.readAsString();
    return "const ${element.name}String = r'''\n$content\n''';";
  }
}

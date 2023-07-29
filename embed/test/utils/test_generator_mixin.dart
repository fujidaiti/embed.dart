import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:embed/src/common/embed_generator.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:mockito/mockito.dart';
import 'package:source_gen/src/constants/reader.dart';

import 'mock_constant_reader.dart';
import 'mock_file.dart';

mixin TestGeneratorMixin<E extends Embed> on EmbeddingGenerator<E> {
  final Map<String, String> _cachedContents = {};

  String _cacheContent(String content, String extension) {
    final hash = Object.hash(content, extension);
    final fakeContentPath = "$hash.$extension";
    _cachedContents[fakeContentPath] = content;
    return fakeContentPath;
  }

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final content = annotation.peek("content");
    final extension = annotation.peek("extension");
    final fakeContentPath = switch ((content, extension)) {
      (var content?, var extension?) =>
        _cacheContent(content.stringValue, extension.stringValue),
      _ => throw StateError("'content' and 'extension' fields must exist in "
          "${annotation.objectValue.type!.getDisplayString(withNullability: false)}"),
    };

    final pathReader = MockConstantReader();
    when(pathReader.stringValue).thenReturn(fakeContentPath);

    final annotationReader = MockConstantReader();
    when(annotationReader.instanceOf(any)).thenReturn(true);
    when(annotationReader.read("path")).thenReturn(pathReader);

    for (final field in additionalAnnotationFields) {
      when(annotationReader.read(field)).thenReturn(annotation.read(field));
    }

    return super.generateForAnnotatedElement(
      element,
      annotationReader,
      buildStep,
    );
  }

  @override
  File resolveContent(config, BuildStep buildStep) {
    assert(_cachedContents.containsKey(config.path));
    final content = _cachedContents[config.path]!;
    final contentFile = MockFile();
    when(contentFile.path).thenReturn(config.path);
    when(contentFile.readAsString()).thenAnswer((_) async => content);
    return contentFile;
  }

  List<String> get additionalAnnotationFields;
}

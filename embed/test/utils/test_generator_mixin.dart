// Ignore deprecated_member_use in order to support a wider range of build and
// source_gen

import 'dart:async';
import 'dart:typed_data';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:embed/src/common/embed_generator.dart';
import 'package:embed/src/common/embedded_content.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:mockito/mockito.dart';
import 'package:source_gen/src/constants/reader.dart';

import 'mock_constant_reader.dart';
import 'test_annotation.dart';

mixin TestGeneratorMixin<E extends Embed> on EmbeddingGenerator<E> {
  final Map<String, String> _cachedStringContents = {};
  final Map<String, Uint8List> _cachedBinaryContents = {};

  String _cacheContent(String content, String extension) {
    final hash = Object.hash(content, extension);
    final fakeContentPath = '$hash.$extension';
    _cachedStringContents[fakeContentPath] = content;
    return fakeContentPath;
  }

  String _cacheBinaryContent(Uint8List content, String extension) {
    final hash = Object.hash(content, extension);
    final fakeContentPath = '$hash.$extension';
    _cachedBinaryContents[fakeContentPath] = content;
    return fakeContentPath;
  }

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final content = annotation.peek('content');
    final extension = annotation.peek('extension');
    final fakeContentPath = switch ((content, extension)) {
      (final content?, final extension?) => content.isString
          ? _cacheContent(content.stringValue, extension.stringValue)
          : _cacheBinaryContent(content.uin8tListValue, extension.stringValue),
      _ =>
        throw StateError("'${annotation.objectValue.type!.getDisplayString()}' "
            "must implement '$TestAnnotation'"),
    };

    final pathReader = MockConstantReader();
    when(pathReader.stringValue).thenReturn(fakeContentPath);

    final annotationReader = MockConstantReader();
    when(annotationReader.instanceOf(any)).thenReturn(true);
    when(annotationReader.read('path')).thenReturn(pathReader);

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
  Future<EmbeddedContent> resolveContent(E config, BuildStep buildStep) async {
    final stringContent = _cachedStringContents[config.path];
    final binaryContent = _cachedBinaryContents[config.path];

    assert(stringContent != null || binaryContent != null);

    return _FakeEmbeddedContent(
      path: config.path,
      stringContent: stringContent,
      binaryContent: binaryContent,
    );
  }

  List<String> get additionalAnnotationFields;
}

class _FakeEmbeddedContent extends EmbeddedContent {
  const _FakeEmbeddedContent({
    required this.path,
    required this.stringContent,
    required this.binaryContent,
  });

  @override
  final String path;

  final String? stringContent;
  final Uint8List? binaryContent;

  @override
  Future<String> readAsString() async => stringContent!;

  @override
  Future<Uint8List> readAsBytes() async => binaryContent!;
}

extension _ConstantReaderUintListExtension on ConstantReader {
  Uint8List get uin8tListValue {
    final list = listValue;
    final bytes = Uint8List(list.length);
    for (var i = 0; i < list.length; ++i) {
      bytes[i] = list[i].toIntValue()!;
    }
    return bytes;
  }
}

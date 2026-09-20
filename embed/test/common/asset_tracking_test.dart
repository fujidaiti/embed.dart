import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:embed/embed.dart';
import 'package:test/test.dart';

/// Verifies that the embedded file is read through the [BuildStep] so that
/// `build_runner` registers it as an input of the build step and regenerates
/// the output when its content changes.
void main() {
  final builder = embedBuilder(BuilderOptions.empty);

  const annotationAsset = {
    'embed_annotation|lib/embed_annotation.dart': '''
class EmbedStr {
  const EmbedStr(this.path, {this.raw = true});
  final String path;
  final bool raw;
}
''',
  };

  const inputAsset = {
    'a|lib/example.dart': r'''
import 'package:embed_annotation/embed_annotation.dart';

part 'example.g.dart';

@EmbedStr('data/text.txt')
const embedded = _$embedded;
''',
  };

  test('reads the embedded file through the build step', () async {
    final readerWriter = TestReaderWriter(rootPackage: 'a');

    await testBuilder(
      builder,
      {
        ...annotationAsset,
        ...inputAsset,
        'a|lib/data/text.txt': 'Hello, embed!',
      },
      outputs: {
        'a|lib/example.embed.g.part': decodedMatches(
          contains("const _\$embedded = r'''\nHello, embed!\n'''"),
        ),
      },
      onLog: (_) {},
      readerWriter: readerWriter,
    );

    expect(
      readerWriter.testing.inputsTracked,
      contains(AssetId('a', 'lib/data/text.txt')),
      reason: 'The embedded file must be tracked as an input of the build '
          'step, otherwise build_runner cannot detect changes to its '
          'content.',
    );
  });

  test('falls back to dart:io when the file is not a readable asset', () async {
    // '/pubspec.yaml' resolves to this package's own pubspec.yaml, which
    // exists on disk but is not part of the in-memory asset set below.
    await testBuilder(
      builder,
      {
        ...annotationAsset,
        'a|lib/example.dart': r'''
import 'package:embed_annotation/embed_annotation.dart';

part 'example.g.dart';

@EmbedStr('/pubspec.yaml')
const embedded = _$embedded;
''',
      },
      outputs: {
        'a|lib/example.embed.g.part': decodedMatches(contains('name: embed')),
      },
      onLog: (_) {},
    );
  });
}

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:embed/embed.dart';
import 'package:test/test.dart';

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

  test('embedded resource file should be tracked', () async {
    final readerWriter = TestReaderWriter(rootPackage: 'a');

    await testBuilder(
      builder,
      {
        ...annotationAsset,
        'a|lib/data/text.txt': 'Hello, embed!',
        'a|lib/example.dart': r'''
import 'package:embed_annotation/embed_annotation.dart';

part 'example.g.dart';

@EmbedStr('data/text.txt')
const embedded = _$embedded;
''',
      },
      outputs: {
        'a|lib/example.embed.g.part': decodedMatches(
          contains(r"const _$embedded = r'''\nHello, embed!\n'''"),
        ),
      },
      onLog: (_) {},
      readerWriter: readerWriter,
    );

    expect(
      readerWriter.testing.inputsTracked,
      contains(AssetId('a', 'lib/data/text.txt')),
    );
  });

  test('files outside lib should not be tracked by default', () async {
    final readerWriter = TestReaderWriter(rootPackage: 'a');

    await testBuilder(
      builder,
      {
        ...annotationAsset,
        'a|data/text.txt': 'This file lives outside lib',
        'a|lib/example.dart': r'''
import 'package:embed_annotation/embed_annotation.dart';

part 'example.g.dart';

@EmbedStr('../data/text.txt')
const embedded = _$embedded;
''',
      },
      outputs: {
        'a|lib/example.embed.g.part': decodedMatches(contains(
            r"const _$embedded = r'''\nThis file lives outside lib\n'''")),
      },
      onLog: (_) {},
      readerWriter: readerWriter,
    );

    expect(
      readerWriter.testing.inputsTracked,
      isNot(contains(AssetId('a', 'data/text.txt'))),
    );
  });
}

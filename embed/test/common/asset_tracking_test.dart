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
          contains("const _\$embedded = r'''\nHello, embed!\n'''"),
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

  test('warn if untrackable file is embedded', () async {
    final logs = <String>[];

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
        'a|lib/example.embed.g.part': decodedMatches(contains(
            'repository: https://github.com/fujidaiti/embed.dart.git')),
      },
      onLog: (record) => logs.add(record.message),
    );

    expect(
      logs,
      contains(endsWith(
        "'/pubspec.yaml' is not included in the build sources, so "
        'build_runner cannot track it. The generated code will not be updated '
        'when the content of the file changes. Add its directory to `sources` '
        'in build.yaml. See '
        'https://pub.dev/packages/build_config#how-can-i-include-additional-sources-in-my-build '
        'for more details.',
      )),
    );
  });
}

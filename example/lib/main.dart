import 'package:yaml/yaml.dart';

void main() {
  YamlMap map = loadYaml(r'''
 name: John Smith
 age: 33
''');

  switch (map) {
    case Map m:
      print("Map");
    case YamlMap m:
      print("yaml m");
  }
}

import 'package:mockito/annotations.dart';
import 'package:source_gen/source_gen.dart';

@GenerateNiceMocks([MockSpec<ConstantReader>()])
export 'mock_constant_reader.mocks.dart';

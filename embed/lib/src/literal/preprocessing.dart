import 'package:embed/src/literal/dart_identifier.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:recase/recase.dart';

class Preprocessing {
  Preprocessing(List<Preprocessor> preprocessors)
      : _preprocessors =
            preprocessors.map(_PreprocessorImpl.from).toList(growable: false);

  final List<_PreprocessorImpl> _preprocessors;

  Object? applyTo(Object? value) => _apply(_transformValue, value);

  Object? _apply(Object? Function(Object? value) f, Object? value) {
    return switch (value) {
      Map values => f(values.map(_applyToKeyValue)),
      List values => f(values.map(applyTo).toList(growable: false)),
      Set values => f(values.map(applyTo).toSet()),
      _ => f(value),
    };
  }

  MapEntry _applyToKeyValue(Object? key, Object? value) =>
      MapEntry(_apply(_transformKey, key), _apply(_transformValue, value));

  Object? _transformKey(Object? key) =>
      _preprocessors.fold(key, (previousValue, preprocessor) {
        return preprocessor.transformKey(previousValue);
      });

  Object? _transformValue(Object? key) =>
      _preprocessors.fold(key, (previousValue, preprocessor) {
        return preprocessor.transformValue(previousValue);
      });
}

abstract class _PreprocessorImpl {
  const _PreprocessorImpl();
  Object? transformKey(Object? key) => key;
  Object? transformValue(Object? value) => value;

  factory _PreprocessorImpl.from(Preprocessor value) {
    return switch (value) {
      Recase() => const _RecaseImpl(),
      EscapeReservedKeywords() => const _EscapeReservedKeywordsImpl(),
      Replace r => _ReplaceImpl(r.pattern, r.replacement, r.onlyFirst),
    };
  }
}

class _RecaseImpl extends _PreprocessorImpl {
  const _RecaseImpl();

  @override
  Object? transformKey(Object? key) {
    return switch (key) {
      String key => key.camelCase,
      _ => key,
    };
  }
}

class _EscapeReservedKeywordsImpl extends _PreprocessorImpl {
  const _EscapeReservedKeywordsImpl();

  @override
  Object? transformKey(Object? key) {
    return switch (key) {
      String key when reservedDartKeywords.contains(key) => "\$$key",
      _ => key,
    };
  }
}

class _ReplaceImpl extends _PreprocessorImpl {
  const _ReplaceImpl(
    this.pattern,
    this.replacement,
    this.onlyFirst,
  );

  final Pattern pattern;
  final String replacement;
  final bool onlyFirst;

  @override
  Object? transformValue(Object? value) => _transform(value);

  @override
  Object? transformKey(Object? key) => _transform(key);

  Object? _transform(Object? value) {
    return switch (value) {
      String value when onlyFirst => value.replaceFirst(pattern, replacement),
      String value => value.replaceAll(pattern, replacement),
      _ => value,
    };
  }
}

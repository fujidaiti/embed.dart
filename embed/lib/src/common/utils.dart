Iterable<(T, U)> zip<T, U>(Iterable<T> a, Iterable<U> b) sync* {
  final iterA = a.iterator;
  final iterB = b.iterator;
  while (iterA.moveNext() && iterB.moveNext()) {
    yield (iterA.current, iterB.current);
  }
}

import '../sample.dart';

/// Sampler for [List] containers.
class ListSampler<T> implements Sampler<List<T>, T> {
  @override
  int size(List<T> xs) => xs.length;

  @override
  T getAt(List<T> xs, int index) => xs[index];
}

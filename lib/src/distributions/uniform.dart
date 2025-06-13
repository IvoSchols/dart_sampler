/// Uniform distribution for sampling indices uniformly from a finite container.
import 'dart:math';
import '../sample.dart';

class UniformDistribution implements Distribution {
  @override
  int nextIndex(int size, Random rng) {
    if (size <= 0) throw StateError('Container must be non-empty');
    return rng.nextInt(size);
  }
}

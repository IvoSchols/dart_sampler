import 'dart:math';

import 'distributions/uniform.dart';

/// How to treat [C] as a finite container of [A]s.
abstract class Sampler<C, A> {
  int size(C container);
  A getAt(C container, int index);
}

/// Strategy for picking an index in [0..size-1].
abstract class Distribution {
  int nextIndex(int size, Random rng);
}

/// Generic sampling function.
A sampleWith<C, A>(
  C container,
  Sampler<C, A> sampler, {
  Distribution? distribution,
  Random? random,
}) {
  final rng = random ?? Random();
  final dist = distribution ?? UniformDistribution();
  final n = sampler.size(container);
  if (n == 0) throw StateError('Cannot sample from an empty container');
  final idx = dist.nextIndex(n, rng);
  return sampler.getAt(container, idx);
}

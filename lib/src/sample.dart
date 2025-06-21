import 'dart:math';

import 'distributions/distributions.dart';

/// Defines how to interpret a container [C] as a finite collection of items of type [A].
abstract class Sampler<C, A> {
  /// Returns the number of elements in [container].
  int size(C container);

  /// Retrieves the element at [index] within [container].
  A getAt(C container, int index);
}

/// Generic sampling function for any container [C] and element [A].
///
/// Uses [sampler] to interpret [container] and [distribution] to pick an index.
A sampleWith<C, A>(
  C container,
  Sampler<C, A> sampler, {
  Distribution? distribution,
  Random? random,
}) {
  final rng = random ?? Random();
  final dist = distribution ?? UniformDistribution();
  final length = sampler.size(container);
  if (length <= 0) {
    throw StateError('Cannot sample from an empty container');
  }

  final index = dist.nextIndex(length, rng);
  return sampler.getAt(container, index);
}

/// Samples multiple elements from a container [C] using the provided [sampler].
///
/// Returns a list of [n] sampled elements.
List<A> sampleManyWith<C, A>(
  C container,
  Sampler<C, A> sampler,
  int n, {
  Distribution? distribution,
  Random? random,
}) {
  if (n <= 0) {
    throw ArgumentError('Sample size must be positive');
  }

  final rng = random ?? Random();
  final dist = distribution ?? UniformDistribution();
  final length = sampler.size(container);

  if (length <= 0) {
    throw StateError('Cannot sample from an empty container');
  }

  return List.generate(
    n,
    (_) => sampler.getAt(container, dist.nextIndex(length, rng)),
  );
}

part of 'distributions.dart';

/// A sampler that uniformly selects an index from [0] to [size - 1].
///
/// Throws a [StateError] if [size] is not positive.
class UniformDistribution implements Distribution {
  /// Returns a random index within a container of length [size].
  @override
  int nextIndex(int size, Random rng) {
    if (size <= 0) {
      throw StateError('Cannot sample from an empty container (size: $size).');
    }
    return rng.nextInt(size);
  }
}

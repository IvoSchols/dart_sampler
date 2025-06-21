part of 'distributions.dart';

/// A sampler that selects an index with probability proportional to given weights.
///
/// Uses a linear scan (cumulative sum) approach:
///  - Setup: O(n) to compute total weight.
///  - Sampling: O(n) per draw.
///
/// Throws [ArgumentError] if [weights] is empty or all weights are non-positive.
class WeightedDistribution implements Distribution {
  /// Immutable copy of input weights.
  final List<double> _weights;

  /// Sum of all weights; guaranteed positive.
  final double _totalWeight;

  /// Creates a [WeightedDistribution] from a list of [weights].
  ///
  /// All weights must be positive. Throws [ArgumentError]
  /// if [weights] is empty or the sum of weights is not positive.
  WeightedDistribution(List<double> weights)
    : assert(weights.isNotEmpty, 'Weights list must not be empty.'),
      _weights = List.unmodifiable(weights),
      _totalWeight = weights.fold(0, (double sum, double w) => sum + w) {
    if (_totalWeight <= 0) {
      throw ArgumentError.value(
        weights,
        'weights',
        'Sum of weights must be positive.',
      );
    }
  }

  @override
  int nextIndex(int size, Random rng) {
    if (size != _weights.length) {
      throw StateError(
        'Container size ($size) does not match weights length (${_weights.length}).',
      );
    }

    /// Generate a random offset in [0, _totalWeight).
    final double target = rng.nextDouble() * _totalWeight;
    double cumulative = 0.0;

    /// Find first index where cumulative weight exceeds target.
    for (var i = 0; i < _weights.length; i++) {
      cumulative += _weights[i];
      if (target < cumulative) {
        return i;
      }
    }

    // Fallback in case of rounding errors:
    return _weights.length - 1;
  }
}

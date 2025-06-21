part of 'distributions.dart';

/// A discrete distribution sampler using Vose's Alias Method.
///
/// Preprocesses weights in O(n) time and provides O(1) sampling.
class AliasDistribution implements Distribution {
  /// Probabilities for each index.
  final List<double> _probabilities;

  /// Alias table mapping.
  final List<int> _aliasTable;

  /// Constructs an [AliasDistribution] from a list of non-negative [weights].
  ///
  /// Throws [ArgumentError] if [weights] is empty or contains non-positive values.
  AliasDistribution(List<double> weights)
    : assert(weights.isNotEmpty, 'Weights list must not be empty.'),
      _probabilities = List.filled(weights.length, 0),
      _aliasTable = List.filled(weights.length, 0) {
    _validateWeights(weights);
    _buildAliasTables(weights);
  }

  @override
  int nextIndex(int size, Random rng) {
    // Sample uniformly from indices
    final index = rng.nextInt(_probabilities.length);
    // Accept or alias
    return rng.nextDouble() < _probabilities[index]
        ? index
        : _aliasTable[index];
  }

  /// Validates that all [weights] are positive.
  void _validateWeights(List<double> weights) {
    if (weights.any((w) => w <= 0)) {
      throw ArgumentError.value(
        weights,
        'weights',
        'All weights must be positive non-zero values.',
      );
    }
  }

  /// Builds the probability and alias tables.
  void _buildAliasTables(List<double> weights) {
    final int n = weights.length;
    final totalWeight = weights.reduce((sum, w) => sum + w);
    final scaled = List<double>.from(weights.map((w) => w * n / totalWeight));

    final small = <int>[];
    final large = <int>[];

    for (var i = 0; i < n; i++) {
      if (scaled[i] < 1.0) {
        small.add(i);
      } else {
        large.add(i);
      }
    }

    while (small.isNotEmpty && large.isNotEmpty) {
      final smaller = small.removeLast();
      final larger = large.removeLast();

      _probabilities[smaller] = scaled[smaller];
      _aliasTable[smaller] = larger;

      scaled[larger] = scaled[larger] - (1.0 - scaled[smaller]);
      if (scaled[larger] < 1.0) {
        small.add(larger);
      } else {
        large.add(larger);
      }
    }

    // Remaining probabilities are 1.0
    for (final index in [...large, ...small]) {
      _probabilities[index] = 1.0;
      _aliasTable[index] = index;
    }
  }
}

import 'dart:math';
import '../sample.dart';

/// Weighted (linear-scan) distribution.
class WeightedDistribution implements Distribution {
  final List<double> weights;
  final double _totalWeight;

  WeightedDistribution(List<double> weights)
    : weights = List.of(weights),
      _totalWeight = weights.fold(0, (sum, w) => sum + w) {
    if (_totalWeight <= 0) {
      throw ArgumentError('Sum of weights must be positive');
    }
  }

  @override
  int nextIndex(int size, Random rng) {
    if (weights.length != size) {
      throw StateError('Weights length must match container size');
    }
    double r = rng.nextDouble() * _totalWeight;
    double cum = 0;
    for (var i = 0; i < size; i++) {
      cum += weights[i];
      if (r < cum) return i;
    }
    return size - 1;
  }
}

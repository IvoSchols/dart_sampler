// test/sampler_test.dart
import 'package:test/test.dart';
import 'dart:math';

import 'package:dart_sampler/dart_sampler.dart';

void main() {
  group('WeightedDistribution', () {
    test('nextIndex respects weights', () {
      final weights = [1.0, 0.0, 0.0];
      final dist = WeightedDistribution(weights);
      final rng = Random(999);
      // Always weight=1 for index 0 only
      expect(dist.nextIndex(3, rng), equals(0));
    });

    test('sampleWith with weighted distribution', () {
      final elements = [10, 20, 30];
      final weights = [0.0, 1.0, 0.0];
      final dist = WeightedDistribution(weights);
      final rng = Random(7);
      final sample = sampleWith<List<int>, int>(
        elements,
        ListSampler<int>(),
        distribution: dist,
        random: rng,
      );
      expect(sample, equals(20));
    });
  });
}

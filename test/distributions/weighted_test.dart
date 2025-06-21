import 'dart:math';

import 'package:test/test.dart';
import 'package:dart_sampler/dart_sampler.dart';

void main() {
  group('WeightedDistribution constructor errors', () {
    test('throws on empty list', () {
      expect(() => WeightedDistribution([]), throwsA(isA<AssertionError>()));
    });

    test('throws when sum of weights is zero', () {
      expect(
        () => WeightedDistribution([0.0, 0.0, 0.0]),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws when sum of weights is negative', () {
      expect(
        () => WeightedDistribution([-1.0, -2.0, 3.0]),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('nextIndex size‐mismatch', () {
    test('throws if size mismatches weights length', () {
      final wd = WeightedDistribution([1, 2, 3]);
      final rng = Random(42);
      expect(() => wd.nextIndex(4, rng), throwsA(isA<StateError>()));
    });
  });

  group('Sampling distribution (statistical)', () {
    test('frequencies converge to weights proportions', () {
      // Weights: [1,2,3] → normalized [1/6, 2/6, 3/6]
      final weights = [1.0, 2.0, 3.0];
      final wd = WeightedDistribution(weights);

      final rng = Random(123456); // fixed seed → deterministic sequence
      final counts = List<int>.filled(weights.length, 0);
      const trials = 60000;

      for (var i = 0; i < trials; i++) {
        counts[wd.nextIndex(weights.length, rng)]++;
      }

      final expected = [1 / 6, 2 / 6, 3 / 6];
      for (var i = 0; i < counts.length; i++) {
        final freq = counts[i] / trials;
        // allow ±1% tolerance
        expect(
          freq,
          closeTo(expected[i], 0.01),
          reason: 'Bucket $i: observed freq $freq, expected ${expected[i]}',
        );
      }
    });
  });
}

import 'dart:math';
import 'package:test/test.dart';
import 'package:dart_sampler/dart_sampler.dart'; // Adjust this import as needed

void main() {
  group('AliasDistribution Constructor Validation', () {
    test('Empty weights list throws AssertionError', () {
      expect(
        () => AliasDistribution(<double>[]),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Non-positive weight throws ArgumentError', () {
      expect(
        () => AliasDistribution([1.0, 0.0, 2.0]),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => AliasDistribution([1.0, -5.0]),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('AliasDistribution Single-Element', () {
    test('Always returns index 0 for single weight', () {
      final rng = Random(123);
      final dist = AliasDistribution([42.0]);
      for (var i = 0; i < 100; i++) {
        expect(dist.nextIndex(1, rng), equals(0));
      }
    });
  });

  group('AliasDistribution Uniform Distribution', () {
    test('Equal weights produce uniform sampling', () {
      const n = 4;
      final weights = List<double>.filled(n, 1.0);
      final dist = AliasDistribution(weights);
      final rng = Random(42);
      final counts = List<int>.filled(n, 0);
      const samples = 100000;

      for (var i = 0; i < samples; i++) {
        final idx = dist.nextIndex(n, rng);
        counts[idx]++;
      }

      // Expect roughly equal counts within 5% tolerance
      final expected = samples / n;
      for (var count in counts) {
        expect(
          (count - expected).abs(),
          lessThanOrEqualTo(expected * 0.05),
          reason:
              'Count $count differs from expected $expected by more than 5%.',
        );
      }
    });
  });

  group('AliasDistribution Weighted Sampling', () {
    test('Sampling matches given weights', () {
      final weights = [1.0, 3.0, 6.0];
      final total = weights.reduce((a, b) => a + b);
      final dist = AliasDistribution(weights);
      final rng = Random(2025);
      final counts = List<int>.filled(weights.length, 0);
      const samples = 100000;

      for (var i = 0; i < samples; i++) {
        final idx = dist.nextIndex(weights.length, rng);
        counts[idx]++;
      }

      // Check each observed frequency is within 3% of the true probability
      for (var i = 0; i < weights.length; i++) {
        final observedProb = counts[i] / samples;
        final expectedProb = weights[i] / total;
        expect(
          (observedProb - expectedProb).abs(),
          lessThanOrEqualTo(0.03),
          reason: 'Index \$i: observed \$observedProb, expected \$expectedProb',
        );
      }
    });
  });

  group('AliasDistribution Deterministic Behavior', () {
    test('Same seed produces same sequence', () {
      final weights = [2.0, 5.0, 3.0];
      final seed = 314159;
      final rng1 = Random(seed);
      final rng2 = Random(seed);
      final dist1 = AliasDistribution(weights);
      final dist2 = AliasDistribution(weights);
      final seq1 = <int>[];
      final seq2 = <int>[];

      for (var i = 0; i < 1000; i++) {
        seq1.add(dist1.nextIndex(weights.length, rng1));
        seq2.add(dist2.nextIndex(weights.length, rng2));
      }

      expect(seq1, equals(seq2));
    });
  });
}

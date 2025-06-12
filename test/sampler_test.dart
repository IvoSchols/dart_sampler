// test/sampler_test.dart
import 'package:test/test.dart';
import 'dart:math';

import 'package:sampler/sampler.dart';

void main() {
  group('UniformDistribution', () {
    final dist = UniformDistribution();
    test('nextIndex returns in-range values', () {
      final rng = Random(123);
      for (var i = 1; i <= 5; i++) {
        final idx = dist.nextIndex(i, rng);
        expect(idx, inInclusiveRange(0, i - 1));
      }
    });

    test('sampleWith List picks correct element', () {
      final List<int> list = [10, 20, 30];
      final Random rng = Random(42);
      final result = sampleWith<List<int>, int>(
        list,
        ListSampler<int>(),
        random: rng,
      );
      // Random(42).nextInt(3) == 0
      expect(result, equals(20));
    });
    test('sampleWith Map picks correct entry', () {
      final Map<String, int> map = {'a': 1, 'b': 2, 'c': 3};
      final Random rng = Random(42);
      final result = sampleWith<Map<String, int>, MapEntry<String, int>>(
        map,
        MapSampler<String, int>(),
        random: rng,
      );
      // Random(42).nextInt(3) == 0
      expect(result.key, equals('b'));
      expect(result.value, equals(2));
    });

    test('sampleWith String picks correct element', () {
      final String list = 'abc';
      final Random rng = Random(42);
      final result = sampleWith<String, String>(
        list,
        StringSampler(),
        random: rng,
      );
      // Random(42).nextInt(3) == 0
      expect(result, equals('b'));
    });
  });

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

  group('AliasMethodDistribution', () {
    final weights = [1.0, 2.0, 3.0];
    final aliasDist = AliasDistribution(weights);
    test('nextIndex returns valid indices', () {
      final rng = Random(42);
      for (var i = 0; i < 10; i++) {
        final idx = aliasDist.nextIndex(weights.length, rng);
        expect(idx, inInclusiveRange(0, weights.length - 1));
      }
    });

    test('alias sampling distribution roughly matches weighted', () {
      final rng = Random(1);
      const trials = 6000;
      final counts = [0, 0, 0];
      for (var i = 0; i < trials; i++) {
        counts[aliasDist.nextIndex(weights.length, rng)]++;
      }
      // Expect count of index2 (~3/6 proportion) to be > 2800
      expect(counts[2], greaterThan(2800));
    });
  });
}

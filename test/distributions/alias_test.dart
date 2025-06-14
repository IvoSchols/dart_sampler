// test/sampler_test.dart
import 'package:test/test.dart';
import 'dart:math';

import 'package:dart_sampler/dart_sampler.dart';

void main() {
  group('AliasDistribution', () {
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

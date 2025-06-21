import 'dart:math';
import 'package:test/test.dart';
import 'package:dart_sampler/dart_sampler.dart';

void main() {
  group('UniformDistribution', () {
    late UniformDistribution distribution;
    late Random rng;

    setUp(() {
      distribution = UniformDistribution();
      rng = Random(42); // Seeded for reproducibility
    });

    test('throws StateError when size <= 0', () {
      expect(() => distribution.nextIndex(0, rng), throwsA(isA<StateError>()));
      expect(() => distribution.nextIndex(-5, rng), throwsA(isA<StateError>()));
    });

    test('returns 0 when size == 1', () {
      expect(distribution.nextIndex(1, rng), equals(0));
    });

    test('returns value in [0, size) for various sizes', () {
      for (var size in [2, 5, 10, 100]) {
        final result = distribution.nextIndex(size, rng);
        expect(result, inInclusiveRange(0, size - 1));
      }
    });

    test('produces roughly uniform distribution', () {
      const size = 5;
      const samples = 10000;
      final counts = List.filled(size, 0);

      for (int i = 0; i < samples; i++) {
        final index = distribution.nextIndex(size, rng);
        counts[index]++;
      }

      final expected = samples / size;
      for (var count in counts) {
        expect(
          count,
          closeTo(expected, expected * 0.1),
          reason: 'Distribution is not uniform enough',
        );
      }
    });
  });
}

import 'package:test/test.dart';
import 'dart:math';

import 'package:dart_sampler/dart_sampler.dart';

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
}

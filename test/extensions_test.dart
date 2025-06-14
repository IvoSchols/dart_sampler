import 'dart:math';

import 'package:dart_sampler/dart_sampler.dart';
import 'package:test/test.dart';

void main() {
  group('IterableSampling Extension (Reservoir sampler)', () {
    test('sample from sync* generator', () {
      Iterable<int> gen() sync* {
        yield 10;
        yield 20;
        yield 30;
      }

      final rng = Random(5);
      final element = gen().sample(random: rng);
      expect([10, 20, 30], contains(element));
    });

    test('sample from Set<T>', () {
      final set = {100, 200, 300};
      final sampled = set.sample(random: Random(7));
      expect(set.contains(sampled), isTrue);
    });

    test('sampling empty iterable throws', () {
      final empty = <int>[];
      expect(() => empty.sample(), throwsStateError);
    });
  });

  group('Remaining Sampler extensions', () {
    test('String sampling', () {
      final str = 'hello';
      final sample = str.sample();
      expect(str.contains(sample), isTrue);
    });

    test('List sampling', () {
      final list = [10, 20, 30];
      final sample = list.sample();
      expect(list.contains(sample), isTrue);
    });

    test('Map sampling', () {
      final map = {'a': 1, 'b': 2, 'c': 3};
      final entry = map.sample();
      expect(map.containsKey(entry.key), isTrue);
      expect(map[entry.key], equals(entry.value));
    });
  });
}

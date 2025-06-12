# Sampler
A Dart library for random sampling from finite containers (String, List, Map) with pluggable distributions and ergonomic extension methods.

## Features
- Uniform sampling of characters, list elements, or map entries.
- Weighted sampling (linear-scan) via WeightedDistribution.
- Alias/Vose method for O(1) weighted sampling via AliasDistribution.
- Type-specific extensions: call .sample() directly on String, List<T>, or Map<K,V>.

## Todo
- Reservoir sampling utilities for batch or streaming scenarios.

# Installation
Add this to your pubspec.yaml:
```yaml
    dependencies:
        sampler: ^1.0.0
```
Then run:
`dart pub get`

Or, if using Flutter:
`flutter pub get`

# Usage
Import the package:
`import 'package:sampler/sampler.dart';`

## Uniform sampling
```dart
    void main() {
    // List
    final nums = [1, 2, 3, 4, 5];
    print(nums.sample()); // e.g. 3

    // String
    final s = 'dartlang';
    print(s.sample()); // e.g. 'a'

    // Map
    final map = {'x': 10, 'y': 20};
    final entry = map.sample();
    print('${entry.key} -> ${entry.value}');

    // Iterable
    Iterable<int> gen() sync* {
        yield 10;
        yield 20;
        yield 30;
      }

    final rng = Random(5);
    final element = gen().sample(random: rng);
    print(element.sample()); // e.g. 10
    }
```
## Weighted sampling
```dart
import 'dart:math';

void main() {
  final items = ['a', 'b', 'c'];
  final weights = [1.0, 2.0, 5.0];

  // Linear-scan weighted
  final dist = WeightedDistribution(weights);
  final selected = items.sample(distribution: dist, random: Random());
  print(selected);

  // Alias method (fast)
  final alias = AliasDistribution(weights);
  print(items.sample(distribution: alias));
}
```


# API Overview
## Core Types
- `Sampler<C, A>`: type-class for indexable containers.
- `Distribution`: strategy for picking an index.
- `sampleWith<C, A>(C container, Sampler<C, A> sampler, {Distribution? distribution, Random? random})`.

## Built-in Samplers
- `StringSampler implements Sampler<String, String>`
- `ListSampler<T> implements Sampler<List<T>, T>`
- `MapSampler<K, V> implements Sampler<Map<K, V>, MapEntry<K, V>>`

## Distributions
- `UniformDistribution`
- `WeightedDistribution`
- `AliasDistribution`

## Extensions
- `String.sample({Distribution? distribution, Random? random})`
- `List<T>.sample({Distribution? distribution, Random? random})`
- `Map<K,V>.sample({Distribution? distribution, Random? random})`
- `Iterable<T>.sample({Distribution? distribution, Random? random})` — sample an element from any Iterable<T>. This will iterate and sample with probability `1/n`.

# Testing
Run all tests with:
`dart test`

# License

MIT © Ivo Schols



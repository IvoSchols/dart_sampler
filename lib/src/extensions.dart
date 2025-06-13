import 'dart:math';
import '../sample.dart';

// 0) Iterable<T> → sample an element
/// Extension on any Iterable<T> to sample an element using reservoir sampling.
extension IterableSampling<T> on Iterable<T> {
  /// Sample one element in O(n) time and O(1) space.
  T sample({Distribution? distribution, Random? random}) {
    final rng = random ?? Random();
    T? result;
    int count = 0;
    for (var element in this) {
      count++;
      // With probability 1/count, select the current element
      if (rng.nextDouble() < 1 / count) {
        result = element;
      }
    }
    if (result == null) {
      throw StateError('Cannot sample from empty iterable');
    }
    return result;
  }
}

// 1) String → sample a character
extension StringSampling on String {
  String sample({Distribution? distribution, Random? random}) {
    return sampleWith<String, String>(
      this,
      StringSampler(),
      distribution: distribution,
      random: random,
    );
  }
}

// 2) List<T> → sample an element
extension ListSampling<T> on List<T> {
  T sample({Distribution? distribution, Random? random}) {
    return sampleWith<List<T>, T>(
      this,
      ListSampler<T>(),
      distribution: distribution,
      random: random,
    );
  }
}

// 3) Map<K,V> → sample a MapEntry
extension MapSampling<K, V> on Map<K, V> {
  MapEntry<K, V> sample({Distribution? distribution, Random? random}) {
    return sampleWith<Map<K, V>, MapEntry<K, V>>(
      this,
      MapSampler<K, V>(),
      distribution: distribution,
      random: random,
    );
  }
}

import 'dart:math';
import '../dart_sampler.dart';

// ====== Iterable Extension (Reservoir Sampling) ======

/// Extension to sample a single element via reservoir sampling.
extension IterableSampling<T> on Iterable<T> {
  /// Samples one element in O(n) time using reservoir sampling.
  ///
  /// Throws [StateError] if the iterable is empty.
  T sample({Random? random}) {
    final rng = random ?? Random();
    T? result;
    var count = 0;
    for (final element in this) {
      count++;
      if (rng.nextDouble() < 1 / count) {
        result = element;
      }
    }
    if (result == null) {
      throw StateError('Cannot sample from an empty iterable');
    }
    return result;
  }

  List<T> sampleMany(int n, {Random? random}) {
    if (n <= 0) {
      throw ArgumentError('Sample size must be positive');
    }
    final rng = random ?? Random();
    final reservoir = <T>[];
    var count = 0;

    for (final element in this) {
      count++;
      if (reservoir.length < n) {
        reservoir.add(element);
      } else {
        final index = rng.nextInt(count);
        if (index < n) {
          reservoir[index] = element;
        }
      }
    }

    if (reservoir.isEmpty) {
      throw StateError('Cannot sample from an empty iterable');
    }
    return reservoir;
  }
}

// ====== Convenience Extensions ======

extension ListSampling<T> on List<T> {
  /// Samples an element using [sampleWith].
  T sample({Distribution? distribution, Random? random}) =>
      sampleWith<List<T>, T>(
        this,
        ListSampler<T>(),
        distribution: distribution,
        random: random,
      );

  /// Samples multiple elements using [sampleManyWith].
  List<T> sampleMany(int n, {Distribution? distribution, Random? random}) =>
      sampleManyWith<List<T>, T>(
        this,
        ListSampler<T>(),
        n,
        distribution: distribution,
        random: random,
      );
}

extension MapSampling<K, V> on Map<K, V> {
  /// Samples a MapEntry &lt;K, V&gt; using [sampleWith].
  MapEntry<K, V> sample({Distribution? distribution, Random? random}) =>
      sampleWith<Map<K, V>, MapEntry<K, V>>(
        this,
        MapSampler<K, V>(),
        distribution: distribution,
        random: random,
      );

  /// Samples multiple MapEntry &lt;K, V&gt; using [sampleManyWith].
  List<MapEntry<K, V>> sampleMany(
    int n, {
    Distribution? distribution,
    Random? random,
  }) => sampleManyWith<Map<K, V>, MapEntry<K, V>>(
    this,
    MapSampler<K, V>(),
    n,
    distribution: distribution,
    random: random,
  );
}

extension StringSampling on String {
  /// Samples a single character as a String using [sampleWith].
  String sample({Distribution? distribution, Random? random}) =>
      sampleWith<String, String>(
        this,
        StringSampler(),
        distribution: distribution,
        random: random,
      );

  /// Samples multiple characters as Strings using [sampleManyWith].
  List<String> sampleMany(
    int n, {
    Distribution? distribution,
    Random? random,
  }) => sampleManyWith<String, String>(
    this,
    StringSampler(),
    n,
    distribution: distribution,
    random: random,
  );
}

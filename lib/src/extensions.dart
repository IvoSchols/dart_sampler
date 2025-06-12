import 'dart:math';
import '../sampler.dart';

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

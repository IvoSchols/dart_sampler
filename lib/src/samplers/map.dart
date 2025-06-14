import '../sample.dart';

/// Sampler for [Map] containers, returning [MapEntry<K, V>].
class MapSampler<K, V> implements Sampler<Map<K, V>, MapEntry<K, V>> {
  @override
  int size(Map<K, V> map) => map.length;

  @override
  MapEntry<K, V> getAt(Map<K, V> map, int index) =>
      map.entries.elementAt(index);
}

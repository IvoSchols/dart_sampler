import '../sample.dart';

class MapSampler<K, V> implements Sampler<Map<K, V>, MapEntry<K, V>> {
  @override
  int size(Map<K, V> m) => m.length;
  @override
  MapEntry<K, V> getAt(Map<K, V> m, int i) => m.entries.elementAt(i);
}

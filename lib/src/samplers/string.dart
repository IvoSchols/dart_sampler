import '../sample.dart';

/// Sampler for [String], returning a single-character [String].
class StringSampler implements Sampler<String, String> {
  @override
  int size(String s) => s.length;

  @override
  String getAt(String s, int index) => s[index];
}

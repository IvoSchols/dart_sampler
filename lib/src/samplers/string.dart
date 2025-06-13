import '../sample.dart';

class StringSampler implements Sampler<String, String> {
  @override
  int size(String s) => s.length;
  @override
  String getAt(String s, int i) => s[i];
}

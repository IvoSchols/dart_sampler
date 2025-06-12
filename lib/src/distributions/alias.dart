import 'dart:math';
import '../sampler.dart';

/// Fast O(1) sampling after O(n) setup via Vose’s alias method.
class AliasDistribution implements Distribution {
  final List<double> _prob;
  final List<int> _alias;

  AliasDistribution(List<double> weights)
    : _prob = List.filled(weights.length, 0),
      _alias = List.filled(weights.length, 0) {
    final n = weights.length;
    final total = weights.reduce((a, b) => a + b);
    final scaled = weights.map((w) => w * n / total).toList();
    final small = <int>[], large = <int>[];

    for (var i = 0; i < n; i++) {
      (scaled[i] < 1 ? small : large).add(i);
    }

    while (small.isNotEmpty && large.isNotEmpty) {
      final l = small.removeLast(), g = large.removeLast();
      _prob[l] = scaled[l];
      _alias[l] = g;
      scaled[g] = (scaled[g] + scaled[l]) - 1;
      if (scaled[g] < 1) {
        small.add(g);
      } else {
        large.add(g);
      }
    }
    for (var leftover in [...large, ...small]) {
      _prob[leftover] = 1;
    }
  }

  @override
  int nextIndex(int size, Random rng) {
    final i = rng.nextInt(_prob.length);
    return rng.nextDouble() < _prob[i] ? i : _alias[i];
  }
}

import 'package:sampler/sampler.dart';

void main() {
  // Uniform character sampling:
  print('hello'.sample()); // => e.g. 'l'

  // Weighted list sampling:
  final nums = [10, 20, 30, 40];
  final weights = [1.0, 1.0, 1.0, 5.0];
  print(nums.sample(distribution: WeightedDistribution(weights))); // prefers 40

  // Alias (fast) sampling:
  print(nums.sample(distribution: AliasDistribution(weights)));
}

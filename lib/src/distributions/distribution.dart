part of 'distributions.dart';

/// Strategy for selecting an index from 0 to size-1.
abstract class Distribution {
  /// Returns a next index given [size] and a [Random] generator.
  int nextIndex(int size, Random rng);
}

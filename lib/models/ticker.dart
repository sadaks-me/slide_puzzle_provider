/// Object to increment time in seconds.
class Ticker {
  const Ticker();

  /// Increments time by 1 second.
  Stream<int> tick() {
    return Stream.periodic(const Duration(seconds: 1), (x) => 1 + x++);
  }
}

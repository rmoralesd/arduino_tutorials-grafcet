class Ticker {
  const Ticker();
  Stream<int> tick(
      {required int millisecondsTickStep, required int currentMilliseconds}) {
    return Stream.periodic(Duration(milliseconds: millisecondsTickStep), (_) {
      currentMilliseconds++;
      //print(currentMilliseconds);
      return currentMilliseconds;
    });
  }
}

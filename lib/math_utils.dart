import "package:collection/collection.dart";

num median<T extends num>(final List<T> dataSet) {
  if (dataSet.isEmpty) throw Exception("Empty List");
  final int middleIndex = dataSet.length ~/ 2;
  final List<T> sortedDataset = dataSet.sorted(
    (final T a, final T b) => a.compareTo(b),
  );
  return (dataSet.length % 2 == 0
      ? (sortedDataset[middleIndex - 1] + sortedDataset[middleIndex]) / 2
      : sortedDataset[middleIndex]);
}

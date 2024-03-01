class StatusItem<T, V> {
  const StatusItem({
    required this.identifier,
    required this.values,
    required this.missingValues,
  });
  final T identifier;
  final List<V> missingValues;
  final List<V> values;
}

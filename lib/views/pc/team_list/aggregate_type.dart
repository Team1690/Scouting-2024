enum AggregateType {
  median,
  max,
  min,
}

extension AggregateTypeExtension on AggregateType {
  String get title {
    switch (this) {
      case AggregateType.median:
        return "Median";
      case AggregateType.max:
        return "Max";
      case AggregateType.min:
        return "Min";
    }
  }
}

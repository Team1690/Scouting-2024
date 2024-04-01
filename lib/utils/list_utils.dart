import "package:collection/collection.dart";

class DeepEqList<T> {
  const DeepEqList(this.list);

  final List<T> list;

  @override
  bool operator ==(final Object other) =>
      other is DeepEqList<T> && ListEquality<T>().equals(other.list, list);

  @override
  int get hashCode => Object.hashAll(list);
}

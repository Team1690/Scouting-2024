import "package:collection/collection.dart";
import "package:scouting_frontend/models/schedule_match.dart";

class DeepEqList<T> {
  const DeepEqList(this.list);

  final List<T> list;

  @override
  bool operator ==(final Object other) =>
      other is DeepEqList<T> && ListEquality<T>().equals(other.list, list);

  @override
  int get hashCode => Object.hashAll(list);
}

extension OrderedScheduleList on List<ScheduleMatch> {
  List<ScheduleMatch> get ordered => sorted(
        (final ScheduleMatch a, final ScheduleMatch b) =>
            a.matchIdentifier.compareTo(b.matchIdentifier),
      );
}

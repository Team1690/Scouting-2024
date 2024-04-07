import "package:flutter/material.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

class ShiftProvider extends InheritedWidget {
  const ShiftProvider({required super.child, required this.shifts});
  final List<ScoutingShift> shifts;
  @override
  bool updateShouldNotify(covariant final ShiftProvider oldWidget) =>
      shifts != oldWidget.shifts;

  static ShiftProvider of(final BuildContext context) {
    final ShiftProvider? result =
        context.dependOnInheritedWidgetOfExactType<ShiftProvider>();
    assert(result != null, "No Scouting Shifts found in context");
    return result!;
  }
}

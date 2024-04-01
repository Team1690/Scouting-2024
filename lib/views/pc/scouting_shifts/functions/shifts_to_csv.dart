import "package:collection/collection.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

String shiftsToCSV(final List<ScoutingShift> shifts) =>
    ",RED 0, RED 1, RED 2, BLUE 0, BLUE 1, BLUE 2\n${shifts.slices(6).map((shift) => "${shift.first.matchIdentifier},${shift.map((e) => "${e.name},").join()}\n").join()}";

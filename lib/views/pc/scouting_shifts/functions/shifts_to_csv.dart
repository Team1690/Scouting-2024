import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

String shiftsToCSV(final List<List<ScoutingShift>> shifts) =>
    ",RED 0, RED 1, RED 2, BLUE 0, BLUE 1, BLUE 2\n${shifts.map((final List<ScoutingShift> shift) => "${shift.first.matchIdentifier},${shift.map((final ScoutingShift e) => "${e.name},").join()}\n").join()}";

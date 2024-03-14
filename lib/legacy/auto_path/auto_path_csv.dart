// import "dart:typed_data";
// import "dart:ui" as ui;

// import "package:collection/collection.dart";
// import "package:scouting_frontend/legacy/auto_path/auto_path.dart";

// Future<Uint8List> createCsv(final Sketch sketch) async => Uint8List.fromList(
//       sketch.points
//           .mapIndexed(
//             (final int index, final ui.Offset element) => index == 0
//                 ? "${element.dx},${element.dy},${sketch.isRed}"
//                 : "${element.dx},${element.dy}",
//           )
//           .join("\n")
//           .codeUnits,
//     );

// ({List<ui.Offset> path, bool isRed}) parseAutoCsv(final String csv) => (
//       path: csv
//           .split("\n")
//           .map((final String e) => e.split(","))
//           .map(
//             (final List<String> e) => ui.Offset(
//               double.tryParse(e[0]) ?? 0,
//               double.tryParse(e[1]) ?? 0,
//             ),
//           )
//           .toList(),
//       isRed:
//           bool.tryParse(csv.split("\n")[0].split(",")[2].replaceAll(" ", "")) ??
//               false
//     );

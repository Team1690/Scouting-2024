// import "dart:ui" as ui;

// import "package:flutter/material.dart";
// import "package:scouting_frontend/legacy/auto_path/multiple_path_canvas.dart";
// import "package:scouting_frontend/views/constants.dart";
// import "package:scouting_frontend/legacy/auto_path/auto_path.dart";

// class PathCanvas extends StatelessWidget {
//   const PathCanvas({
//     super.key,
//     required this.sketch,
//     required this.fieldImages,
//   });
//   final Sketch sketch;

//   final (ui.Image, ui.Image) fieldImages;

//   @override
//   Widget build(final BuildContext context) => AspectRatio(
//         aspectRatio: autoFieldWidth / fieldheight,
//         child: LayoutBuilder(
//           builder: (
//             final BuildContext context,
//             final BoxConstraints constraints,
//           ) =>
//               MultiplePathCanvas(
//             sketches: <(Sketch, ui.Color)>[(sketch, Colors.white)],
//             fieldImage: sketch.isRed ? fieldImages.$1 : fieldImages.$2,
//           ),
//         ),
//       );
// }

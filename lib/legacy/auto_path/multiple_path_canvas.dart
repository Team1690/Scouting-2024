// import "dart:ui" as ui;

// import "package:flutter/material.dart";
// import "package:scouting_frontend/views/constants.dart";
// import "package:scouting_frontend/legacy/auto_path/auto_path.dart";

// class MultiplePathCanvas extends StatelessWidget {
//   const MultiplePathCanvas({
//     super.key,
//     required this.sketches,
//     required this.fieldImage,
//   });
//   final List<(Sketch, Color)> sketches;

//   final ui.Image fieldImage;

//   @override
//   Widget build(final BuildContext context) => AspectRatio(
//         aspectRatio: autoFieldWidth / fieldheight,
//         child: LayoutBuilder(
//           builder: (
//             final BuildContext context,
//             final BoxConstraints constraints,
//           ) =>
//               CustomPaint(
//             painter: DrawingCanvas(
//               width: 3,
//               fieldBackground: fieldImage,
//               sketches: sketches
//                   .map(
//                     (final (Sketch, ui.Color) sketchToColor) => (
//                       Sketch(
//                         isRed: sketchToColor.$1.isRed,
//                         url: sketchToColor.$1.url,
//                         points: sketchToColor.$1.points
//                             .map(
//                               (final ui.Offset e) => e.scale(
//                                 constraints.maxWidth / autoFieldWidth,
//                                 constraints.maxHeight / fieldheight,
//                               ),
//                             )
//                             .toList(),
//                       ),
//                       sketchToColor.$2
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//         ),
//       );
// }

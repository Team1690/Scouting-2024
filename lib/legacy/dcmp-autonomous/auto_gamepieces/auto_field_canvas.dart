// import "dart:ui" as ui;

// import "package:collection/collection.dart";
// import "package:flutter/material.dart";
// import "package:scouting_frontend/legacy/dcmp-autonomous/auto_gamepiece_id_enum.dart";
// import "package:scouting_frontend/views/constants.dart";
// import "package:scouting_frontend/legacy/dcmp-autonomous/auto_gamepieces/auto_gamepieces_view.dart";

// class AutoFieldCanvas extends CustomPainter {
//   AutoFieldCanvas({
//     required this.fieldBackground,
//     required this.gamepieceOrder,
//     required this.meterToPixelRatio,
//     required this.selectedGamepiece,
//     required this.context,
//   });
//   final BuildContext context;
//   final ui.Image fieldBackground;
//   final List<AutoGamepieceID> gamepieceOrder;
//   final double meterToPixelRatio;
//   final AutoGamepieceID? selectedGamepiece;

//   @override
//   void paint(final Canvas canvas, final ui.Size size) async {
//     canvas.drawImageRect(
//       fieldBackground,
//       Rect.fromLTWH(
//         0,
//         0,
//         fieldBackground.width.toDouble(),
//         fieldBackground.height.toDouble(),
//       ),
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       Paint(),
//     );

//     for (int i = 0; i < gamepieceOrder.length; i++) {
//       final TextPainter frontTextPainter = TextPainter(
//         text: TextSpan(
//           text: i.toString(),
//           style: TextStyle(
//             color: selectedGamepiece == gamepieceOrder[i]
//                 ? Colors.red
//                 : Colors.white,
//             fontSize: isPC(context) ? 40 : 20,
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//       );
//       frontTextPainter.layout(
//         minWidth: 0,
//         maxWidth: size.width,
//       );
//       final double textHorizontalOffset = (frontTextPainter.width) / 2;
//       final double textVerticalOffset = (frontTextPainter.height) / 2;
//       frontTextPainter.paint(
//         canvas,
//         notesPlacements.entries
//             .firstWhereOrNull(
//               (final MapEntry<ui.Offset, AutoGamepieceID> element) =>
//                   element.value == gamepieceOrder[i],
//             )!
//             .key
//             .scale(meterToPixelRatio, meterToPixelRatio)
//             .translate(textHorizontalOffset, -textVerticalOffset),
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant final AutoFieldCanvas oldDelegate) => true;
// }

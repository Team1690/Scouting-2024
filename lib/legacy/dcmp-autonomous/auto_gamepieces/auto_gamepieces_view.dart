// import "dart:ui" as ui;

// import "package:flutter/material.dart";
// import "package:flutter/services.dart";
// import "package:scouting_frontend/legacy/dcmp-autonomous/auto_gamepiece_id_enum.dart";
// import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
// import "package:scouting_frontend/views/constants.dart";
// import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
// import "package:scouting_frontend/legacy/dcmp-autonomous/auto_gamepieces/auto_screen_input.dart";

// class AutoGamepiecesScreen extends StatelessWidget {
//   const AutoGamepiecesScreen({super.key});

//   @override
//   Widget build(final BuildContext context) => isPC(context)
//       ? DashboardScaffold(
//           body: const Padding(
//             padding: EdgeInsets.all(defaultPadding),
//             child: AutoScreenInput(),
//           ),
//         )
//       : Scaffold(
//           appBar: AppBar(
//             title: const Text("Alliance Auto"),
//             centerTitle: true,
//           ),
//           drawer: SideNavBar(),
//           body: Padding(
//             padding: const EdgeInsets.all(defaultPadding),
//             child: isPC(context)
//                 ? const AutoScreenInput()
//                 : const SingleChildScrollView(
//                     child: AutoScreenInput(),
//                     scrollDirection: Axis.vertical,
//                   ),
//           ),
//         );
// }

// Future<ui.Image> getField(final bool isRed) async {
//   final ByteData data = await rootBundle
//       .load("lib/assets/frc_2024_field_${isRed ? "red" : "blue"}.png");
//   final ui.Codec codec =
//       await ui.instantiateImageCodec(data.buffer.asUint8List());
//   final ui.FrameInfo frameInfo = await codec.getNextFrame();
//   return frameInfo.image;
// }

// final Map<Offset, AutoGamepieceID> notesPlacements =
//     Map<Offset, AutoGamepieceID>.unmodifiable(
//   Map<Offset, AutoGamepieceID>.fromEntries(
//     <(ui.Offset, AutoGamepieceID)>[
//       (const Offset(0, fieldheight / 2), AutoGamepieceID.zero),
//       (const Offset(2.88, 1.22), AutoGamepieceID.one),
//       (const Offset(2.88, 2.65), AutoGamepieceID.two),
//       (const Offset(2.88, 3.88), AutoGamepieceID.three),
//       (const Offset(8.2, 0.75), AutoGamepieceID.four),
//       (const Offset(8.2, 2.395), AutoGamepieceID.five),
//       (const Offset(8.2, 4.05), AutoGamepieceID.six),
//       (const Offset(8.2, 5.7), AutoGamepieceID.seven),
//       (const Offset(8.2, 7.04), AutoGamepieceID.eight),
//     ].map(
//       (final (ui.Offset, AutoGamepieceID) e) =>
//           MapEntry<Offset, AutoGamepieceID>(e.$1, e.$2),
//     ),
//   ),
// );

// bool inTolerance(
//   final double val,
//   final double target,
//   final double tolerance,
// ) =>
//     val <= target + tolerance && val >= target - tolerance;

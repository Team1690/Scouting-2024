// import "dart:ui" as ui;

// import "package:flutter/material.dart";
// import "package:scouting_frontend/models/data/team_data/team_data.dart";
// import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
// import "package:scouting_frontend/models/team_model.dart";
// import "package:scouting_frontend/net/hasura_helper.dart";
// import "package:scouting_frontend/views/common/team_selection_future.dart";
// import "package:scouting_frontend/views/constants.dart";
// import "package:scouting_frontend/legacy/dcmp-autonomous/auto_gamepieces/auto_gamepiece_data.dart";
// import "package:scouting_frontend/legacy/dcmp-autonomous/auto_gamepieces/auto_gamepieces_view.dart";

// class AutoScreenInput extends StatefulWidget {
//   const AutoScreenInput({super.key});

//   @override
//   State<AutoScreenInput> createState() => _AutoScreenInputState();
// }

// class _AutoScreenInputState extends State<AutoScreenInput> {
//   LightTeam? team;
//   ui.Image? field;
//   TextEditingController controller = TextEditingController();
//   @override
//   Widget build(final BuildContext context) => Column(
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 1,
//                 child: TeamSelectionFuture(
//                   onChange: (final LightTeam p0) async {
//                     field = await getField(false);
//                     setState(() {
//                       team = p0;
//                     });
//                   },
//                   controller: controller,
//                 ),
//               ),
//               Expanded(
//                 child: Container(),
//                 flex: isPC(context) ? 2 : 0,
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           if (team != null && field != null)
//             Expanded(
//               flex: isPC(context) ? 1 : 0,
//               child: StreamBuilder<TeamData>(
//                 stream: fetchSingleTeamData(team!.id, context),
//                 builder: (
//                   final BuildContext context,
//                   final AsyncSnapshot<TeamData> snapshot,
//                 ) =>
//                     snapshot.mapSnapshot(
//                   onWaiting: () => const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                   onError: (final Object error) => Text(error.toString()),
//                   onNoData: () => const Center(
//                     child: Text("No data"),
//                   ),
//                   onSuccess: (final TeamData data) =>
//                       AutoGamepiecesData(data: data, field: field!),
//                 ),
//               ),
//             ),
//         ],
//       );
// }

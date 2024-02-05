import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_data/all_team_data.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/coach_team_info_data.dart";
import "package:scouting_frontend/views/pc/team_info/team_info_screen.dart";
import "package:flutter_switch/flutter_switch.dart";

class AutoPickList extends StatefulWidget {
  AutoPickList({
    required this.uiList,
  });

  @override
  State<AutoPickList> createState() => _AutoPickListState();
  final List<AutoPickListTeam> uiList;
}

class _AutoPickListState extends State<AutoPickList> {
  @override
  Widget build(final BuildContext context) => Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.uiList
                .map<Widget>(
                  (final AutoPickListTeam autoPickListTeam) => Card(
                    color: bgColor,
                    key: ValueKey<String>(autoPickListTeam.toString()),
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(
                        0,
                        defaultPadding / 4,
                        0,
                        defaultPadding / 4,
                      ),
                      child: isPC(context)
                          ? ExpansionTile(
                              children: <Widget>[
                                ListTile(
                                  title: Row(
                                    //TODO, the commented part should remain the same if you initialized a fault messages variable.
                                    children: <Widget>[
                                      // Expanded(
                                      //   flex: 2,
                                      //   child: Row(
                                      //     children: <Widget>[
                                      //       const Spacer(),
                                      //       Expanded(
                                      //         child: Icon(
                                      //           autoPickListTeam
                                      //               .picklistTeam.faultMessages
                                      //               .fold(
                                      //             () => Icons.check,
                                      //             (final List<String> _) =>
                                      //                 Icons.warning,
                                      //           ),
                                      //           color: autoPickListTeam
                                      //               .picklistTeam.faultMessages
                                      //               .fold(
                                      //             () => Colors.green,
                                      //             (final List<String> _) =>
                                      //                 Colors.yellow[700],
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       Expanded(
                                      //         flex: 2,
                                      //         child: Text(
                                      //           autoPickListTeam.picklistTeam
                                      //                   .faultMessages
                                      //                   .mapNullable(
                                      //                 (
                                      //                   final List<String> p0,
                                      //                 ) =>
                                      //                     "Faults: ${p0.length}",
                                      //               ) ??
                                      //               "No faults",
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      //TODO display the rest of your variables
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute<TeamInfoScreen>(
                                              builder: (
                                                final BuildContext context,
                                              ) =>
                                                  TeamInfoScreen(
                                                initalTeam: autoPickListTeam
                                                    .picklistTeam.team,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "Team info",
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      autoPickListTeam.toString(),
                                    ),
                                  ),
                                ]
                                    .expand(
                                      (final Widget element) => <Widget>[
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        element,
                                      ],
                                    )
                                    .toList(),
                              ),
                              trailing: const SizedBox(),
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  FlutterSwitch(
                                    value: autoPickListTeam.picklistTeam.taken,
                                    activeColor: Colors.red,
                                    inactiveColor: primaryColor,
                                    height: 25,
                                    width: 100,
                                    onToggle: (final bool val) {
                                      autoPickListTeam.picklistTeam.taken = val;
                                    },
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onDoubleTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<CoachTeamData>(
                                    builder: (final BuildContext context) =>
                                        CoachTeamData(
                                      autoPickListTeam.picklistTeam.team,
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        autoPickListTeam.toString(),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const SizedBox(),
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    FlutterSwitch(
                                      value:
                                          autoPickListTeam.picklistTeam.taken,
                                      activeColor: Colors.red,
                                      inactiveColor: primaryColor,
                                      height: 25,
                                      width: 50,
                                      onToggle: (final bool val) {
                                        autoPickListTeam.picklistTeam.taken =
                                            val;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
}

int validateId(final int id) =>
    id <= 0 ? throw ArgumentError("Invalid Id") : id;
int validateNumber(final int number) =>
    number < 0 ? throw ArgumentError("Invalid Team Number") : number;
String validateName(final String name) =>
    name == "" ? throw ArgumentError("Invalid Team Name") : name;

//TODO add your season specific factors
class AutoPickListTeam {
  AutoPickListTeam({
    required this.factor1,
    required this.factor2,
    required this.facotr3,
    required this.picklistTeam,
  });

  final AllTeamData picklistTeam;
  final double factor1;
  final double factor2;
  final double facotr3;

  @override
  String toString() => "${picklistTeam.team.name} ${picklistTeam.team.number}";
}

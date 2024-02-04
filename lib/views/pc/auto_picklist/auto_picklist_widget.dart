import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_data/all_team_data.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
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
  final List<AllTeamData> uiList;
}

class _AutoPickListState extends State<AutoPickList> {
  @override
  Widget build(final BuildContext context) => Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.uiList
                .map<Widget>(
                  (final AllTeamData autoPickListTeam) => Card(
                    color: bgColor,
                    key: ValueKey<String>(autoPickListTeam.toString()),
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 4,
                      ),
                      child: isPC(context)
                          ? ExpansionTile(
                              children: <Widget>[
                                ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "Tele Amp\n Average: ${autoPickListTeam.aggregateData.avgData.teleAmp.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Tele Speaker\n Average: ${autoPickListTeam.aggregateData.avgData.teleSpeaker.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Auto Amp\n Average: ${autoPickListTeam.aggregateData.avgData.autoAmp.toStringAsFixed(2)}",
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Auto Speaker\n Average: ${autoPickListTeam.aggregateData.avgData.autoSpeaker.toStringAsFixed(2)}",
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Trap Amount\n Average: ${autoPickListTeam.aggregateData.avgData.trapAmount.toStringAsFixed(2)}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            autoPickListTeam.faultMessages.fold(
                                              Icons.check,
                                              (final _, final __) =>
                                                  Icons.warning,
                                            ),
                                            color: autoPickListTeam
                                                .faultMessages
                                                .fold(
                                              Colors.green,
                                              (final _, final __) =>
                                                  Colors.yellow[700],
                                            ),
                                          ),
                                          Text(
                                            autoPickListTeam.faultMessages
                                                    .mapNullable(
                                                  (
                                                    final List<String> p0,
                                                  ) =>
                                                      "Faults: ${p0.length}",
                                                ) ??
                                                "No faults",
                                          ),
                                        ],
                                      ),

                                      //TODO display the rest of your variables
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute<TeamInfoScreen>(
                                            builder: (
                                              final BuildContext context,
                                            ) =>
                                                TeamInfoScreen(
                                              initalTeam: autoPickListTeam.team,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Team info",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      autoPickListTeam.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Aim: ${autoPickListTeam.aim.toStringAsFixed(2)}%",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Climbed: ${autoPickListTeam.climbPercentage.toStringAsFixed(2)}%",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Worked: ${autoPickListTeam.workedPercentage.toStringAsFixed(2)}%",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Matches: ${autoPickListTeam.aggregateData.gamesPlayed}",
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
                                    value: autoPickListTeam.taken,
                                    activeColor: Colors.red,
                                    inactiveColor: primaryColor,
                                    height: 25,
                                    width: 100,
                                    onToggle: (final bool val) {
                                      autoPickListTeam.taken = val;
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
                                      autoPickListTeam.team,
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
                                      value: autoPickListTeam.taken,
                                      activeColor: Colors.red,
                                      inactiveColor: primaryColor,
                                      height: 25,
                                      width: 50,
                                      onToggle: (final bool val) {
                                        autoPickListTeam.taken = val;
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

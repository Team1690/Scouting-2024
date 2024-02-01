import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/fetch_functions/all_teams/all_team_data.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/coach_team_info_data.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_screen.dart";
import "package:scouting_frontend/views/pc/team_info/team_info_screen.dart";
import "package:flutter_switch/flutter_switch.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class PickList extends StatefulWidget {
  PickList({
    required this.uiList,
    required this.screen,
    required this.onReorder,
  }) {
    uiList.sort(
      (final AllTeamData a, final AllTeamData b) =>
          screen.getIndex(a).compareTo(screen.getIndex(b)),
    );
  }
  final CurrentPickList screen;
  final void Function(List<AllTeamData> list) onReorder;

  @override
  State<PickList> createState() => _PickListState();
  final List<AllTeamData> uiList;
}

class _PickListState extends State<PickList> {
  void reorderData(final int oldindex, int newindex) {
    if (newindex > oldindex) {
      newindex -= 1;
    }
    final AllTeamData item = widget.uiList.removeAt(oldindex);
    widget.uiList.insert(newindex, item);
    for (int i = 0; i < widget.uiList.length; i++) {
      widget.screen.setIndex(widget.uiList[i], i);
    }
    widget.onReorder(widget.uiList);
  }

  @override
  Widget build(final BuildContext context) {
    final List<TextEditingController> controllers = <TextEditingController>[
      for (int i = 0; i < widget.uiList.length; i++)
        TextEditingController(text: "${i + 1}"),
    ];
    return Container(
      child: ReorderableListView(
        buildDefaultDragHandles: true,
        primary: false,
        children: widget.uiList
            .map(
              (final AllTeamData pickListTeam) => Card(
                color: bgColor,
                key: ValueKey<String>(pickListTeam.toString()),
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
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        Expanded(
                                          child: Icon(
                                            pickListTeam.faultMessages.isEmpty
                                                ? Icons.check
                                                : Icons.warning,
                                            color: pickListTeam
                                                    .faultMessages.isEmpty
                                                ? Colors.green
                                                : Colors.yellow[700],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            pickListTeam.faultMessages
                                                    .mapNullable(
                                                  (
                                                    final List<String> p0,
                                                  ) =>
                                                      "Faults: ${p0.length}",
                                                ) ??
                                                "No faults",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (pickListTeam.amountOfMatches != 0)

                                    //TODO display the rest of your variables
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute<TeamInfoScreen>(
                                            builder:
                                                (final BuildContext context) =>
                                                    TeamInfoScreen(
                                              initalTeam: pickListTeam.team,
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
                                  pickListTeam.toString(),
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
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  minLines: 1,
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 18),
                                  controller: controllers[
                                      widget.screen.getIndex(pickListTeam)],
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (final String value) =>
                                      setState(() {
                                    reorderData(
                                      widget.screen.getIndex(
                                        pickListTeam,
                                      ),
                                      int.tryParse(value).mapNullable(
                                            (final int parsedInt) =>
                                                (parsedInt - 1) %
                                                widget.uiList.length,
                                          ) ??
                                          widget.screen.getIndex(
                                            pickListTeam,
                                          ),
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              FlutterSwitch(
                                value: pickListTeam.taken,
                                activeColor: Colors.red,
                                inactiveColor: primaryColor,
                                height: 25,
                                width: 100,
                                onToggle: (final bool val) {
                                  pickListTeam.taken = val;
                                  widget.onReorder(widget.uiList);
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
                                    CoachTeamData(pickListTeam.team),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    pickListTeam.toString(),
                                  ),
                                ),
                              ],
                            ),
                            trailing: const SizedBox(),
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: 36,
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 10),
                                    controller:
                                        controllers[widget.screen.getIndex(
                                      pickListTeam,
                                    )],
                                    keyboardType: TextInputType.number,
                                    onFieldSubmitted: (final String value) =>
                                        setState(() {
                                      reorderData(
                                        widget.screen.getIndex(
                                          pickListTeam,
                                        ),
                                        int.tryParse(value).mapNullable(
                                              (final int parsedInt) =>
                                                  (parsedInt - 1) %
                                                  widget.uiList.length,
                                            ) ??
                                            widget.screen.getIndex(
                                              pickListTeam,
                                            ),
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                FlutterSwitch(
                                  value: pickListTeam.taken,
                                  activeColor: Colors.red,
                                  inactiveColor: primaryColor,
                                  height: 25,
                                  width: 50,
                                  onToggle: (final bool val) {
                                    pickListTeam.taken = val;
                                    widget.onReorder(widget.uiList);
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
        onReorder: reorderData,
      ),
    );
  }
}

int validateId(final int id) =>
    id <= 0 ? throw ArgumentError("Invalid Id") : id;
int validateNumber(final int number) =>
    number < 0 ? throw ArgumentError("Invalid Team Number") : number;
String validateName(final String name) =>
    name == "" ? throw ArgumentError("Invalid Team Name") : name;

//TODO add season specific variables, make sure to include amountOfMatches and faultMessages which should always be useful.


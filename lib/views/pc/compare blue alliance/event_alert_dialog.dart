import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_toggle.dart";
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/blue_alliance_match_data.dart";
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/fetch_match_results.dart";

class EventAlertDialog extends StatefulWidget {
  @override
  State<EventAlertDialog> createState() => _EventAlertDialogState();
}

class _EventAlertDialogState extends State<EventAlertDialog> {
  TextEditingController controller = TextEditingController();
  bool isIsrael = false;
  Map<String, bool> usComp = <String, bool>{
    "cc": false,
    "iri": false,
    "worlds": false,
  };
  Map<String, bool> israelComp = <String, bool>{
    "cmp": false,
    "ios": false,
    "de": false,
  };
  Map<String, bool> districtNum = <String, bool>{
    "1": false,
    "2": false,
    "3": false,
    "4": false,
  };
  Map<String, bool> whatSubDivision = <String, bool>{
    "arc": false,
    "cur": false,
    "dal": false,
    "gal": false,
    "hop": false,
    "joh": false,
    "mil": false,
    "new": false,
    "cmptx": false,
  };

  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: const Text("Choose Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Year"),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                child: PitToggle(
                  isSelected: <bool>[isIsrael],
                  onPressed: (final int i) {
                    setState(() {
                      isIsrael = !isIsrael;
                      isIsrael
                          ? usComp.updateAll(
                              (final String key, bool value) => value = false,
                            )
                          : israelComp.updateAll(
                              (final String key, bool value) => value = false,
                            );
                      isIsrael
                          ? whatSubDivision.updateAll(
                              (final String key, bool value) => value = false,
                            )
                          : districtNum.updateAll(
                              (final String key, bool value) => value = false,
                            );
                    });
                  },
                  titles: const <String>[" Is Israel? "],
                ),
              ),
            ),
            isIsrael
                ? Center(
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PitToggle(
                          onPressed: (final int index) {
                            setState(() {
                              !israelComp["de"]!
                                  ? districtNum.updateAll(
                                      (final String key, bool value) =>
                                          value = false,
                                    )
                                  : null;
                              israelComp.updateAll(
                                (final String key, bool value) => value = false,
                              );
                              final List<String> keys =
                                  israelComp.keys.toList();
                              final String key = keys[index];
                              israelComp[key] = !israelComp[key]!;
                            });
                          },
                          isSelected: israelComp.values.toList(),
                          titles: const <String>[
                            " Dcmp? ",
                            " Ios? ",
                            " District? ",
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PitToggle(
                        onPressed: (final int index) {
                          setState(() {
                            !usComp["worlds"]!
                                ? whatSubDivision.updateAll(
                                    (final String key, bool value) =>
                                        value = false,
                                  )
                                : null;
                            usComp.updateAll(
                              (final String key, bool value) => value = false,
                            );
                            final List<String> keys = usComp.keys.toList();
                            final String key = keys[index];
                            usComp[key] = !usComp[key]!;
                          });
                        },
                        isSelected: usComp.values.toList(),
                        titles: const <String>[
                          " Chezy Champs ",
                          " IRI",
                          " Worlds ",
                        ],
                      ),
                    ),
                  ),
            usComp["worlds"]! && !isIsrael
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PitToggle(
                        onPressed: (final int index) {
                          setState(() {
                            whatSubDivision.updateAll(
                              (final String key, bool value) => value = false,
                            );
                            final List<String> keys =
                                whatSubDivision.keys.toList();
                            final String key = keys[index];
                            whatSubDivision[key] = !whatSubDivision[key]!;
                          });
                        },
                        isSelected: whatSubDivision.values.toList(),
                        titles: const <String>[
                          " Archimedes Division ",
                          " Curie Division ",
                          " Daly Division ",
                          " Galileo Division ",
                          " Hopper Division ",
                          " Johnson Division ",
                          " Milstein Division ",
                          " Newton Division ",
                          " Einstein Field ",
                        ],
                      ),
                    ),
                  )
                : Container(),
            israelComp.values.last && isIsrael
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PitToggle(
                        onPressed: (final int index) {
                          setState(() {
                            districtNum.updateAll(
                              (final String key, bool value) => value = false,
                            );
                            final List<String> keys = districtNum.keys.toList();
                            final String key = keys[index];
                            districtNum[key] = !districtNum[key]!;
                          });
                        },
                        isSelected: districtNum.values.toList(),
                        titles: const <String>[
                          " Dis 1 ",
                          " Dis 2 ",
                          " Dis 3 ",
                          " Dis 4 ",
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              getWebsiteData(
                parseEvent(
                  isIsrael,
                  israelComp,
                  districtNum,
                  whatSubDivision,
                  controller.text,
                  usComp,
                ),
              ).then(
                (final List<BlueAllianceMatchData>? value) =>
                    Navigator.pop(context, value),
              );
            },
            child: const Text("Submit Button"),
          ),
        ],
      );
}

String parseEvent(
  final bool isIsreal,
  final Map<String, bool> israelComp,
  final Map<String, bool> districtNum,
  final Map<String, bool> whatSubDivision,
  final String year,
  final Map<String, bool> usComp,
) {
  final String isrealCompKey = israelComp.values.contains(true)
      ? israelComp.entries
          .firstWhere(
            (final MapEntry<String, bool> entry) => entry.value == true,
          )
          .key
      : "";
  final String districtNumKey = districtNum.values.contains(true)
      ? districtNum.entries
          .firstWhere(
            (final MapEntry<String, bool> entry) => entry.value == true,
          )
          .key
      : "";
  final String whatSubDivisionKey = whatSubDivision.values.contains(true)
      ? whatSubDivision.entries
          .firstWhere(
            (final MapEntry<String, bool> entry) => entry.value == true,
          )
          .key
      : "";
  final bool worlds = usComp["worlds"]!;
  usComp.remove("worlds");
  final String usCompKey = usComp.values.contains(true)
      ? usComp.entries
          .firstWhere(
            (final MapEntry<String, bool> entry) => entry.value == true,
          )
          .key
      : "";
  return "$year${isIsreal ? "is" : ""}$isrealCompKey$districtNumKey${worlds ? whatSubDivisionKey : ""}$usCompKey";
}

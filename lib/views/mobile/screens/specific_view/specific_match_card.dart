import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/data/starting_position_enum.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/auto_path/path_canvas.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/firebase_submit_button.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path_csv.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/fetch_auto_path.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_ratings.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_vars.dart";
import "package:scouting_frontend/views/mobile/submit_button.dart";
import "package:scouting_frontend/views/mobile/team_and_match_selection.dart";

class SpecificMatchCard extends StatefulWidget {
  const SpecificMatchCard({required this.onTeamSelected});
  final void Function(LightTeam) onTeamSelected;
  @override
  State<SpecificMatchCard> createState() => _SpecificMatchCardState();
}

class _SpecificMatchCardState extends State<SpecificMatchCard> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController matchController = TextEditingController();
  final TextEditingController faultsController = TextEditingController();

  (ui.Image, ui.Image)? fieldImages;
  late SpecificVars vars = SpecificVars(context);
  bool intialIsRed = false;
  late Future<
      List<
          ({
            Sketch sketch,
            StartingPosition startingPos,
            MatchIdentifier matchIdentifier
          })>> pathsFuture = Future<
      List<
          ({
            Sketch sketch,
            StartingPosition startingPos,
            MatchIdentifier matchIdentifier
          })>>(
    () => <({
      Sketch sketch,
      StartingPosition startingPos,
      MatchIdentifier matchIdentifier
    })>[],
  );

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: FutureBuilder<List<AutoPathData>>(
          future: pathsFuture,
          builder: (
            final BuildContext context,
            final AsyncSnapshot<List<AutoPathData>> snapshot,
          ) =>
              SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    validator: (final String? value) =>
                        value != null && value.isNotEmpty
                            ? null
                            : "Please enter your name",
                    onChanged: (final String p0) {
                      setState(() {
                        vars = vars.copyWith(name: always(p0));
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      hintText: "Scouter names",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TeamAndMatchSelection(
                    matchController: matchController,
                    teamNumberController: teamController,
                    onChange: (
                      final ScheduleMatch selectedMatch,
                      final LightTeam? selectedTeam,
                    ) {
                      setState(() {
                        vars = vars.copyWith(
                          scheduleMatch: always(selectedMatch),
                          team: always(selectedTeam),
                          autoPath: always(null),
                        );
                        if (selectedTeam != null) {
                          widget.onTeamSelected(selectedTeam);

                          pathsFuture = getPaths(vars.team!.id, true);
                        }
                        final ScheduleMatch? scheduleMatch = vars.scheduleMatch;
                        if (scheduleMatch != null &&
                            !<MatchType>[
                              MatchType.pre,
                              MatchType.practice,
                            ].contains(
                              scheduleMatch.matchIdentifier.type,
                            )) {
                          intialIsRed =
                              scheduleMatch.redAlliance.contains(vars.team);
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ToggleButtons(
                    fillColor: const Color.fromARGB(10, 244, 67, 54),
                    selectedColor: Colors.red,
                    selectedBorderColor: Colors.red,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Rematch"),
                      ),
                    ],
                    isSelected: <bool>[vars.isRematch],
                    onPressed: (final int i) {
                      setState(() {
                        vars = vars.copyWith(
                          isRematch: always(!vars.isRematch),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              snapshot.data != null && snapshot.data!.isNotEmpty
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey,
                                    ),
                        ),
                        onPressed: () async {
                          fieldImages =
                              (await getField(true), await getField(false));
                          final Sketch? result = await showPathSelectionDialog(
                            context,
                            snapshot.data
                                    ?.map(
                                      (
                                        final ({
                                          Sketch sketch,
                                          StartingPosition startingPos,
                                          MatchIdentifier matchIdentifier
                                        }) autoData,
                                      ) =>
                                          autoData.sketch,
                                    )
                                    .toList() ??
                                <Sketch>[],
                            intialIsRed,
                          );
                          setState(() {
                            vars = vars.copyWith(
                              autoPath: always(result ?? vars.autoPath),
                            );
                          });
                        },
                        child: const Text("Create Auto Path"),
                      ),
                      TextButton(
                        onPressed: () async {
                          fieldImages =
                              (await getField(true), await getField(false));
                          final Sketch result = Sketch(
                            points: <ui.Offset>[],
                            isRed: intialIsRed,
                            url: "",
                          );
                          setState(() {
                            vars = vars.copyWith(
                              autoPath: always(result),
                            );
                          });
                        },
                        child: const Text(
                          "Auto Not Moving",
                          selectionColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  if (vars.autoPath != null && fieldImages != null) ...<Widget>[
                    const SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: PathCanvas(
                        sketch: vars.autoPath!,
                        fieldImages: fieldImages!,
                      ),
                    ),
                  ],
                  const SizedBox(height: 15.0),
                  SpecificRating(
                    onChanged: (final SpecificVars vars) => setState(() {
                      this.vars = vars;
                    }),
                    vars: vars,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "Robot fault:     ",
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: ToggleButtons(
                            fillColor: const Color.fromARGB(10, 244, 67, 54),
                            focusColor: const Color.fromARGB(170, 244, 67, 54),
                            highlightColor:
                                const Color.fromARGB(170, 244, 67, 54),
                            selectedBorderColor:
                                const Color.fromARGB(170, 244, 67, 54),
                            selectedColor: Colors.red,
                            children: const <Widget>[
                              Icon(
                                Icons.cancel,
                              ),
                            ],
                            isSelected: <bool>[
                              vars.faultMessage != null,
                            ],
                            onPressed: (final int index) {
                              assert(index == 0);
                              setState(() {
                                vars = vars.copyWith(
                                  faultMessage: always(
                                    vars.faultMessage.onNull("No input"),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: vars.faultMessage == null
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Container(),
                    secondChild: TextField(
                      controller: faultsController,
                      textDirection: TextDirection.rtl,
                      onChanged: (final String value) {
                        setState(() {
                          vars = vars.copyWith(
                            faultMessage: always(value),
                          );
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Robot fault",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: submitButtons(
                      "auto_paths/${vars.scheduleMatch?.id}_${vars.team?.id}.txt",
                      () {
                        setState(() {
                          pathsFuture = Future<
                              List<
                                  ({
                                    Sketch sketch,
                                    StartingPosition startingPos,
                                    MatchIdentifier matchIdentifier
                                  })>>(
                            () => <({
                              Sketch sketch,
                              StartingPosition startingPos,
                              MatchIdentifier matchIdentifier
                            })>[],
                          );
                          vars = vars.reset(context);
                          teamController.clear();
                          matchController.clear();
                          faultsController.clear();
                        });
                      },
                      getMutation(vars.faultMessage),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<Sketch?> showPathSelectionDialog(
    final BuildContext context,
    final List<Sketch> sketches,
    final bool isRed,
  ) =>
      Navigator.push<Sketch>(
        context,
        MaterialPageRoute<Sketch>(
          builder: (final BuildContext buildContext) => AutoPath(
            initialPath: vars.autoPath,
            existingPaths: sketches,
            fieldBackgrounds: fieldImages!,
            initialIsRed: isRed,
          ),
        ),
      );
  Widget submitButtons(
    final String filePath,
    final void Function() resetForm,
    final String mutation,
  ) =>
      vars.autoPath != null
          ? vars.autoPath!.url == null
              ? FireBaseSubmitButton(
                  filePath: filePath,
                  getResult: () => createCsv(vars.autoPath!),
                  vars: vars,
                  validate: () => formKey.currentState!.validate(),
                  resetForm: resetForm,
                  mutation: mutation,
                )
              : SubmitButton(
                  getJson: () => vars.toJson(),
                  validate: () => formKey.currentState!.validate(),
                  resetForm: resetForm,
                  mutation: mutation,
                )
          : Container();
}

Future<ui.Image> getField(final bool isRed) async {
  final ByteData data = await rootBundle
      .load("lib/assets/frc_2024_field_${isRed ? "red" : "blue"}.png");
  final ui.Codec codec =
      await ui.instantiateImageCodec(data.buffer.asUint8List());
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}

String getMutation(final String? faultMessage) => """
                mutation A( \$defense_rating: Int, \$driving_rating: Int, \$general_rating: Int, \$intake_rating: Int, \$is_rematch: Boolean, \$speaker_rating: Int, \$scouter_name: String, \$team_id: Int, \$url: String, \$climb_rating: Int, \$amp_rating: Int, \$schedule_match_id: Int, \$fault_message:String){
                  insert_specific_match(objects: {scouter_name: \$scouter_name, team_id: \$team_id, speaker_rating: \$speaker_rating, schedule_match_id: \$schedule_match_id, url: \$url, is_rematch: \$is_rematch, intake_rating: \$intake_rating, general_rating: \$general_rating, driving_rating: \$driving_rating, defense_rating: \$defense_rating, climb_rating: \$climb_rating, amp_rating: \$amp_rating}) {
                    affected_rows
                  }
                  ${faultMessage == null ? "" : """
                  insert_faults(objects: {team_id: \$team_id, message: \$fault_message, schedule_match_id: \$schedule_match_id, }) {
                    affected_rows
                  }"""}
                      }
                
                """;

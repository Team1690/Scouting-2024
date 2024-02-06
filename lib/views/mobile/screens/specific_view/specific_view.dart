import "dart:async";
import "dart:ui" as ui;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/mobile/firebase_submit_button.dart";
import "package:scouting_frontend/views/mobile/screens/robot_image.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path_csv.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/fetch_auto_path.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/path_canvas.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_ratings.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_summary_card.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_vars.dart";
import "package:scouting_frontend/views/mobile/submit_button.dart";
import "package:scouting_frontend/views/mobile/team_and_match_selection.dart";

class Specific extends StatefulWidget {
  @override
  State<Specific> createState() => _SpecificState();
}

class _SpecificState extends State<Specific> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController matchController = TextEditingController();
  final TextEditingController faultsController = TextEditingController();
  final FocusNode node = FocusNode();

  (ui.Image, ui.Image)? fieldImages;
  late SpecificVars vars = SpecificVars(context);
  bool intialIsRed = false;
  late Future<List<Sketch>> pathsFuture = Future<List<Sketch>>(
    () => <Sketch>[],
  );

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: node.unfocus,
        child: Scaffold(
          drawer: SideNavBar(),
          appBar: AppBar(
            actions: <Widget>[RobotImageButton(teamId: () => vars.team?.id)],
            centerTitle: true,
            title: const Text("Specific"),
          ),
          body: CarouselWithIndicator(
            widgets: <Widget>[
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: FutureBuilder<List<Sketch>>(
                  future: pathsFuture,
                  builder: (
                    final BuildContext context,
                    final AsyncSnapshot<List<Sketch>> snapshot,
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
                              vars = vars.copyWith(name: always(p0));
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
                                if (vars.team != null) {
                                  pathsFuture = getPaths(vars);
                                }
                                final ScheduleMatch? scheduleMatch =
                                    vars.scheduleMatch;
                                if (scheduleMatch != null &&
                                    !<MatchType>[
                                      MatchType.pre,
                                      MatchType.practice,
                                    ].contains(
                                      scheduleMatch.matchIdentifier.type,
                                    )) {
                                  intialIsRed = scheduleMatch.redAlliance
                                      .contains(vars.team);
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
                          ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: snapshot.data != null &&
                                      snapshot.data!.isNotEmpty
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey,
                                    ),
                            ),
                            onPressed: () async {
                              fieldImages =
                                  (await getField(true), await getField(false));
                              final Sketch? result =
                                  await showPathSelectionDialog(
                                context,
                                snapshot.data ?? <Sketch>[],
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
                          if (vars.autoPath != null &&
                              fieldImages != null) ...<Widget>[
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
                            onChanged: (final SpecificVars vars) =>
                                setState(() {
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
                                    fillColor:
                                        const Color.fromARGB(10, 244, 67, 54),
                                    focusColor:
                                        const Color.fromARGB(170, 244, 67, 54),
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
                                            vars.faultMessage
                                                .onNull("No input"),
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
                                vars =
                                    vars.copyWith(faultMessage: always(value));
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
                                  pathsFuture = Future<List<Sketch>>(
                                    () => <Sketch>[],
                                  );
                                  vars = vars.reset(context);
                                  nameController.clear();
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
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: SpecificSummaryCard(),
              ),
            ],
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
                mutation A(\$defense_amount_id: Int, \$defense_rating: Int, \$driving_rating: Int, \$general_rating: Int, \$intake_rating: Int, \$is_rematch: Boolean, \$speaker_rating: Int, \$scouter_name: String, \$team_id: Int, \$url: String, \$climb_rating: Int, \$amp_rating: Int, \$schedule_match_id: Int, \$fault_message:String){
                  insert_specific_match(objects: {scouter_name: \$scouter_name, team_id: \$team_id, speaker_rating: \$speaker_rating, schedule_match_id: \$schedule_match_id, url: \$url, is_rematch: \$is_rematch, intake_rating: \$intake_rating, general_rating: \$general_rating, driving_rating: \$driving_rating, defense_rating: \$defense_rating, defense_amount_id: \$defense_amount_id, climb_rating: \$climb_rating, amp_rating: \$amp_rating}) {
                    affected_rows
                  }
                  ${faultMessage == null ? "" : """
                  insert_faults(objects: {team_id: \$team_id, message: \$fault_message, match_type_id: \$schedule_match_id,}) {
                    affected_rows
                  }"""}
                      }
                
                """;

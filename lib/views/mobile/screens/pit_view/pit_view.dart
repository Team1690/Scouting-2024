import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:image_picker/image_picker.dart";
import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/enums/shooting_range_enum.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/image_picker_widget.dart";
import "package:scouting_frontend/views/mobile/submit_buttons/submit/firebase_submit_button.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_toggle.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/widgets/measurement_conversion.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_vars.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/mobile/submit_buttons/submit/submit_button.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/widgets/teams_without_pit.dart";
import "package:scouting_frontend/models/providers/team_provider.dart";

const double kgToPoundFactor = 2.20462262;
const double mToFt = 1 / 0.3048;
const double cmToInch = 0.393700787;

class PitView extends StatefulWidget {
  const PitView([this.initialVars]);
  final PitVars? initialVars;

  @override
  State<PitView> createState() => _PitViewState();
}

FormFieldValidator<String> numericValidator(final String error) =>
    (final String? text) => double.tryParse(text ?? "").onNull(error);

class _PitViewState extends State<PitView> {
  LightTeam? team;

  XFile? userImage;
  late PitVars vars = PitVars(context);
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController teamSelectionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final FocusNode node = FocusNode();
  final ValueNotifier<bool> advancedSwitchController =
      ValueNotifier<bool>(false);
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  bool kg = true;
  bool lengthcm = true;
  bool widthcm = true;

  void resetFrame() {
    setState(() {
      vars = vars.reset();
      lengthController.clear();
      widthController.clear();
      weightController.clear();
      notesController.clear();
      teamSelectionController.clear();
      userImage = null;
      advancedSwitchController.value = false;
      kg = true;
      widthcm = true;
      lengthcm = true;
    });
  }

  @override
  void initState() {
    super.initState();
    vars = widget.initialVars ?? PitVars(context);
    weightController.text = vars.weight != null ? vars.weight.toString() : "";
    lengthController.text = vars.length != null ? vars.length.toString() : "";
    widthController.text = vars.width != null ? vars.width.toString() : "";
    notesController.text = vars.notes;
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: node.unfocus,
        child: Scaffold(
          drawer: SideNavBar(),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<Scaffold>(
                      builder: (final BuildContext context) =>
                          const TeamsWithoutPit(),
                    ),
                  );
                },
                icon: const Icon(Icons.build),
              ),
            ],
            centerTitle: true,
            title: const Text("Pit"),
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: widget.initialVars == null,
                      child: TeamSelectionFuture(
                        teams: TeamProvider.of(context).teams,
                        controller: teamSelectionController,
                        onChange: (final LightTeam lightTeam) {
                          vars = vars.copyWith(
                            teamId: () => lightTeam.id,
                          );
                        },
                      ),
                    ),
                    SectionDivider(label: "Drive Train"),
                    Selector<DriveTrain>(
                      validate: (final DriveTrain? result) =>
                          result.onNull("Please pick a drivetrain"),
                      makeItem: (final DriveTrain drivetrain) =>
                          drivetrain.title,
                      placeholder: "Choose a drivetrain",
                      value: vars.driveTrainType,
                      options: DriveTrain.values,
                      onChange: (final DriveTrain newValue) {
                        setState(() {
                          vars = vars.copyWith(
                            driveTrainType: () => newValue,
                          );
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Selector<DriveMotor>(
                      validate: (final DriveMotor? result) =>
                          result.onNull("Please pick a drivemotor"),
                      placeholder: "Choose a drivemotor",
                      makeItem: (final DriveMotor drivemotor) =>
                          drivemotor.title,
                      value: vars.driveMotorType,
                      options: DriveMotor.values,
                      onChange: (final DriveMotor newValue) {
                        setState(() {
                          vars = vars.copyWith(driveMotorType: () => newValue);
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MeasurementConversion(
                      controller: weightController,
                      title: "Weight",
                      unitTypes: const <String>["KG", "LBS"],
                      regularUnitsToOtherUnitsFactor: kgToPoundFactor,
                      onValueChange: (final double? value) {
                        setState(() {
                          vars = vars.copyWith(weight: () => value);
                        });
                      },
                      onRegularUnits: kg,
                      currentValue: vars.weight,
                      onUnitsChange: (final bool newKg) {
                        setState(() {
                          kg = newKg;
                        });
                      },
                      icon: Icons.fitness_center,
                    ),
                    MeasurementConversion(
                      controller: lengthController,
                      title: "Length",
                      unitTypes: const <String>["CM", "INCH"],
                      regularUnitsToOtherUnitsFactor: cmToInch,
                      onValueChange: (final double? value) {
                        setState(() {
                          vars = vars.copyWith(length: () => value);
                        });
                      },
                      onRegularUnits: lengthcm,
                      currentValue: vars.length,
                      onUnitsChange: (final bool newKg) {
                        setState(() {
                          lengthcm = newKg;
                        });
                      },
                      icon: Icons.legend_toggle,
                    ),
                    MeasurementConversion(
                      controller: widthController,
                      title: "Width",
                      unitTypes: const <String>["CM", "INCH"],
                      regularUnitsToOtherUnitsFactor: cmToInch,
                      onValueChange: (final double? value) {
                        setState(() {
                          vars = vars.copyWith(width: () => value);
                        });
                      },
                      onRegularUnits: widthcm,
                      currentValue: vars.width,
                      onUnitsChange: (final bool newKg) {
                        setState(() {
                          widthcm = newKg;
                        });
                      },
                      icon: Icons.compare,
                    ),
                    SectionDivider(label: "OnStage"),
                    Switcher(
                      labels: <String>[
                        ShootingRange.freeRange.title,
                        ShootingRange.subwoofer.title,
                      ],
                      colors: const <Color>[
                        Colors.white,
                        Colors.white,
                      ],
                      onChange: (final int selection) {
                        setState(() {
                          vars = vars.copyWith(
                            allRangeShooting: () => <int, ShootingRange>{
                              0: ShootingRange.subwoofer,
                              1: ShootingRange.freeRange,
                            }[selection],
                          );
                        });
                      },
                      selected: vars.allRangeShooting.mapNullable(
                            (final ShootingRange canAllRangeShoot) =>
                                canAllRangeShoot.index == 1 ? 1 : 0,
                          ) ??
                          -1,
                      borderRadiusGeometry: defaultBorderRadius,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        PitToggle(
                          onPressed: () => setState(() {
                            final bool newClimb = !vars.climb;
                            vars = vars.copyWith(
                              climb: always(newClimb),
                              harmony: always(false),
                            );
                          }),
                          isSelected: vars.climb,
                          title: "Climb",
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (vars.climb) ...<Widget>[
                          PitToggle(
                            onPressed: () => setState(() {
                              vars = vars.copyWith(
                                harmony: always(!vars.harmony),
                              );
                            }),
                            isSelected: vars.harmony,
                            title: "Can Harmonize",
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                        PitToggle(
                          onPressed: () => setState(() {
                            vars = vars.copyWith(
                              canEject: always(!vars.canEject),
                            );
                          }),
                          isSelected: vars.canEject,
                          title: "Can Eject",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        PitToggle(
                          onPressed: () => setState(() {
                            vars = vars.copyWith(
                              canPassUnderStage:
                                  always(!vars.canPassUnderStage),
                            );
                          }),
                          isSelected: vars.canPassUnderStage,
                          title: "Can Pass Under Stage",
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        PitToggle(
                          onPressed: () => setState(() {
                            vars = vars.copyWith(
                              trap: always(!vars.trap),
                            );
                          }),
                          isSelected: vars.trap,
                          title: "Can Trap",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: widget.initialVars == null,
                      child: Column(
                        children: <Widget>[
                          SectionDivider(label: "Robot Image"),
                          ImagePickerWidget(
                            validate: (final XFile? image) =>
                                userImage.onNull("Please pick an Image"),
                            controller: advancedSwitchController,
                            onImagePicked: (final XFile newResult) =>
                                userImage = newResult,
                          ),
                        ],
                      ),
                    ),
                    SectionDivider(label: "Notes"),
                    TextField(
                      focusNode: node,
                      textDirection: TextDirection.rtl,
                      controller: notesController,
                      onChanged: (final String notes) {
                        setState(() {
                          vars = vars.copyWith(
                            notes: () => notes,
                          );
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 4.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 4.0),
                        ),
                        fillColor: secondaryColor,
                        filled: true,
                      ),
                      maxLines: 18,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ...<Widget>[
                      widget.initialVars == null
                          ? FireBaseSubmitButton(
                              validate: () => formKey.currentState!.validate(),
                              getResult: () => userImage!
                                  .readAsBytes(), // Saftey, Validation requires result to be non null
                              filePath:
                                  "/files/pit_photos/${vars.teamId}.${(userImage?.path.substring((userImage?.path.lastIndexOf(".") ?? 0) + 1))}",
                              mutation: insertMutation,
                              vars: vars,
                              resetForm: resetFrame,
                            )
                          : SubmitButton(
                              getJson: vars.toJson,
                              mutation: updateMutation,
                              resetForm: resetFrame,
                              validate: () => formKey.currentState!.validate(),
                            ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

const String insertMutation = r"""
mutation InsertPit($climb: Boolean!, $shooting_range_id: Int, $can_eject: Boolean!, $can_pass_under_stage: Boolean!, $drivetrain_id: Int, $drivemotor_id: Int, $width: float8!, $weight: float8!, $url: String!, $trap: Boolean!, $team_id: Int, $notes: String, $length: float8!, $harmony: Boolean!) {
  insert_pit(objects: {climb: $climb, shooting_range_id: $shooting_range_id, can_eject: $can_eject, can_pass_under_stage: $can_pass_under_stage, drivetrain_id: $drivetrain_id, drivemotor_id: $drivemotor_id, width: $width, weight: $weight, url: $url, trap: $trap, team_id: $team_id, notes: $notes, length: $length, harmony: $harmony}) {
    affected_rows
  }
}
""";

const String updateMutation = r"""
mutation UpdatePit( $climb: Boolean!, $drivemotor_id: Int, $drivetrain_id: Int, $notes: String, $team_id: Int, $weight: float8!, $harmony: Boolean!, $trap: Boolean!, $url: String!, $can_eject: Boolean!, $can_pass_under_stage: Boolean!, $length: float8!, $width: float8!, $shooting_range_id: Int) {
  update_pit(where: { team_id: {_eq: $team_id}}, _set: { climb: $climb, drivemotor_id: $drivemotor_id, drivetrain_id: $drivetrain_id, notes: $notes, team_id: $team_id, weight: $weight, harmony: $harmony, trap: $trap, url: $url, can_eject: $can_eject, can_pass_under_stage: $can_pass_under_stage, length: $length, width: $width, shooting_range_id: $shooting_range_id}) {
    affected_rows
  }
}
""";

Stream<List<LightTeam>> fetchTeamsWithoutPit() => getClient()
    .subscribe(
      SubscriptionOptions<List<LightTeam>>(
        parserFn: (final Map<String, dynamic> data) =>
            (data["team"] as List<dynamic>).map(LightTeam.fromJson).toList(),
        document: gql(
          r"""
query NoPit {
  team(where:  {_not: { pit: {} } }) {
    number
    name
    id
    colors_index
  }
}
""",
        ),
      ),
    )
    .map(
      queryResultToParsed,
    );

import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:image_picker/image_picker.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/image_picker_widget.dart";
import "package:scouting_frontend/views/mobile/firebase_submit_button.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/widgets/measurement_conversion.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_vars.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/mobile/submit_button.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/widgets/teams_without_pit.dart";

const double kgToPoundFactor = 2.20462262;
const double mToFt = 1 / 0.3048;

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
  final TextEditingController weightController = TextEditingController();
  bool kg = true;
  bool meters = true;

  void resetFrame() {
    setState(() {
      vars = vars.reset();
      weightController.clear();
      notesController.clear();
      teamSelectionController.clear();
      userImage = null;
      advancedSwitchController.value = false;
      kg = true;
      meters = true;
    });
  }

  @override
  void initState() {
    super.initState();
    vars = widget.initialVars ?? PitVars(context);
    weightController.text = vars.weight != null ? vars.weight.toString() : "";
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
                    Selector<int>(
                      validate: (final int? result) =>
                          result.onNull("Please pick a drivetrain"),
                      makeItem: (final int drivetrainId) =>
                          IdProvider.of(context)
                              .driveTrain
                              .idToName[drivetrainId]!,
                      placeholder: "Choose a drivetrain",
                      value: vars.driveTrainType,
                      options: IdProvider.of(context)
                          .driveTrain
                          .idToName
                          .keys
                          .toList(),
                      onChange: (final int newValue) {
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
                    Selector<int>(
                      validate: (final int? result) =>
                          result.onNull("Please pick a drivemotor"),
                      placeholder: "Choose a drivemotor",
                      makeItem: (final int drivemotorId) =>
                          IdProvider.of(context)
                              .drivemotor
                              .idToName[drivemotorId]!,
                      value: vars.driveMotorType,
                      options: IdProvider.of(context)
                          .drivemotor
                          .idToName
                          .keys
                          .toList(),
                      onChange: (final int newValue) {
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
                    SectionDivider(label: "OnStage"),
                    Switcher(
                      borderRadiusGeometry: defaultBorderRadius,
                      selected: vars.harmony.mapNullable(
                            (final bool canHarmonize) => canHarmonize ? 1 : 0,
                          ) ??
                          -1,
                      labels: const <String>[
                        "Can't Harmonize",
                        "Can Harmonize",
                      ],
                      colors: const <Color>[
                        Colors.white,
                        Colors.white,
                      ],
                      onChange: (final int selection) {
                        setState(() {
                          vars = vars.copyWith(
                            harmony: () =>
                                <int, bool>{1: true, 0: false}[selection],
                          );
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Switcher(
                      borderRadiusGeometry: defaultBorderRadius,
                      selected: vars.canEject.mapNullable(
                            (final bool canEject) => canEject ? 1 : 0,
                          ) ??
                          -1,
                      labels: const <String>[
                        "Can't Eject",
                        "Can Eject",
                      ],
                      colors: const <Color>[
                        Colors.white,
                        Colors.white,
                      ],
                      onChange: (final int selection) {
                        setState(() {
                          vars = vars.copyWith(
                            canEject: () =>
                                <int, bool>{1: true, 0: false}[selection],
                          );
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Switcher(
                      borderRadiusGeometry: defaultBorderRadius,
                      selected: vars.canEject.mapNullable(
                            (final bool canEject) => canEject ? 1 : 0,
                          ) ??
                          -1,
                      labels: const <String>[
                        "Can't Eject",
                        "Can Eject",
                      ],
                      colors: const <Color>[
                        Colors.white,
                        Colors.white,
                      ],
                      onChange: (final int selection) {
                        setState(() {
                          vars = vars.copyWith(
                            canEject: () =>
                                <int, bool>{1: true, 0: false}[selection],
                          );
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Switcher(
                      borderRadiusGeometry: defaultBorderRadius,
                      selected: vars.trap,
                      labels: const <String>[
                        "Can't Trap",
                        "Can Trap",
                        "Can Trap Twice",
                      ],
                      colors: const <Color>[
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ],
                      onChange: (final int selection) {
                        setState(() {
                          vars = vars.copyWith(
                            trap: () => selection,
                          );
                        });
                      },
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
mutation InsertPit( $drivemotor_id: Int, $drivetrain_id: Int, $wheel_type_id: Int, $other_wheel_type: String, $gearbox_purchased: Boolean!, $notes: String, $has_shifter: Boolean, $team_id: Int, $weight: float8!, $height: float8!, $harmony: Boolean!, $trap: Int!, $has_buddy_climb: Boolean!, $url: String!, $can_eject: Boolean!) {
  insert_pit(objects: [{ drivemotor_id: $drivemotor_id, drivetrain_id: $drivetrain_id, wheel_type_id: $wheel_type_id, other_wheel_type: $other_wheel_type, gearbox_purchased: $gearbox_purchased, notes: $notes, has_shifter: $has_shifter, team_id: $team_id, weight: $weight, height: $height, harmony: $harmony, trap: $trap, has_buddy_climb: $has_buddy_climb, url: $url, can_eject: $can_eject}]) {
    affected_rows
  }
}
""";

const String updateMutation = r"""
mutation UpdatePit( $drivemotor_id: Int, $drivetrain_id: Int, $wheel_type_id: Int, $other_wheel_type: String, $gearbox_purchased: Boolean!, $notes: String, $has_shifter: Boolean, $team_id: Int, $weight: float8!, $height: float8!, $harmony: Boolean!, $trap: Int!, $has_buddy_climb: Boolean!, $url: String!, $can_eject: Boolean!) {
  update_pit(where: {team_id: {_eq: $team_id}}, _set: { drivemotor_id: $drivemotor_id, drivetrain_id: $drivetrain_id, wheel_type_id: $wheel_type_id, other_wheel_type: $other_wheel_type, gearbox_purchased: $gearbox_purchased, notes: $notes, has_shifter: $has_shifter, team_id: $team_id, weight: $weight, height: $height, harmony: $harmony, trap: $trap, has_buddy_climb: $has_buddy_climb, url: $url, can_eject: $can_eject}) {
    affected_rows
  }
}""";

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

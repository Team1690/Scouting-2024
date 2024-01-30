import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:graphql/client.dart";
import "package:image_picker/image_picker.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/image_picker_widget.dart";
import "package:scouting_frontend/views/mobile/firebase_submit_button.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_vars.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/mobile/submit_button.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/teams_without_pit.dart";

class PitView extends StatefulWidget {
  const PitView([this.initialVars]);
  final PitVars? initialVars;

  @override
  State<PitView> createState() => _PitViewState();
}

class _PitViewState extends State<PitView> {
  LightTeam? team;

  XFile? userImage;
  late PitVars vars = PitVars(context);
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController wheelTypeOtherController =
      TextEditingController();
  bool otherWheelTypeSelected = false;
  final TextEditingController teamSelectionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final FocusNode node = FocusNode();
  final ValueNotifier<bool> advancedSwitchController =
      ValueNotifier<bool>(false);
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  FormFieldValidator<String> _numericValidator(final String error) =>
      (final String? text) => int.tryParse(text ?? "").onNull(error);

  void resetFrame() {
    setState(() {
      vars = vars.reset();
      weightController.clear();
      heightController.clear();
      notesController.clear();
      wheelTypeOtherController.clear();
      teamSelectionController.clear();
      userImage = null;
      advancedSwitchController.value = false;
    });
  }

  @override
  void initState() {
    super.initState();
    vars = widget.initialVars ?? PitVars(context);
    weightController.text = vars.weight != null ? vars.weight.toString() : "";
    heightController.text = vars.height != null ? vars.height.toString() : "";
    notesController.text = vars.notes;
    wheelTypeOtherController.text = "";
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
                    Selector<int>(
                      options: IdProvider.of(context)
                          .driveWheel
                          .idToName
                          .keys
                          .toList(),
                      placeholder: "Choose a drive wheel",
                      value: vars.driveWheelType,
                      makeItem: (final int wheelType) => IdProvider.of(context)
                          .driveWheel
                          .idToName[wheelType]!,
                      onChange: (final int newValue) {
                        setState(() {
                          otherWheelTypeSelected = IdProvider.of(context)
                                  .driveWheel
                                  .idToName[newValue] ==
                              "Other";
                          vars = vars.copyWith(
                            driveWheelType: () => newValue,
                          );
                        });
                      },
                      validate: (final int? wheelType) => wheelType == null
                          ? "please enter the robot's wheel type"
                          : null,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: otherWheelTypeSelected,
                      child: TextFormField(
                        controller: wheelTypeOtherController,
                        onChanged: (final String specifiedWheel) {
                          setState(() {
                            vars = vars.copyWith(
                              otherDriveWheelType: () => specifiedWheel,
                            );
                          });
                        },
                        validator: (final String? otherWheelOption) =>
                            otherWheelTypeSelected &&
                                    (otherWheelOption == null ||
                                        otherWheelOption.isEmpty)
                                ? "Please specify \"Other\" wheel type"
                                : null,
                        decoration: const InputDecoration(
                          labelText: "\"Other\" drive wheel type",
                        ),
                      ),
                    ),
                    Counter(
                      count: vars.driveMotorAmount,
                      label: "Drive Motors",
                      icon: Icons.speed,
                      upperLimit: 10,
                      lowerLimit: 2,
                      stepValue: 2,
                      longPressedValue: 4,
                      onChange: (final int newValue) {
                        setState(() {
                          vars = vars.copyWith(
                            driveMotorAmount: () => newValue,
                          );
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Switcher(
                      borderRadiusGeometry: defaultBorderRadius,
                      selected: vars.hasShifter.mapNullable(
                            (final bool hasShifter) => hasShifter ? 0 : 1,
                          ) ??
                          -1,
                      labels: const <String>[
                        "Shifter",
                        "No shifter",
                      ],
                      colors: const <Color>[
                        Colors.white,
                        Colors.white,
                      ],
                      onChange: (final int selection) {
                        setState(() {
                          vars = vars.copyWith(
                            hasShifter: () =>
                                <int, bool>{1: false, 0: true}[selection],
                          );
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Switcher(
                      borderRadiusGeometry: defaultBorderRadius,
                      selected: vars.gearboxPurchased.mapNullable(
                            (final bool gearboxPurchased) =>
                                gearboxPurchased ? 0 : 1,
                          ) ??
                          -1,
                      labels: const <String>[
                        "Purchased GearBox",
                        "Custom GearBox",
                      ],
                      colors: const <Color>[
                        Colors.white,
                        Colors.white,
                      ],
                      onChange: (final int selection) {
                        setState(() {
                          vars = vars.copyWith(
                            gearboxPurchased: () =>
                                <int, bool>{1: false, 0: true}[selection],
                          );
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: weightController,
                      onChanged: (final String weight) {
                        vars = vars.copyWith(
                          weight: () => double.tryParse(weight),
                        );
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: "Weight",
                        prefixIcon: Icon(Icons.fitness_center),
                      ),
                      validator: _numericValidator(
                        "please enter the robot's weight",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: heightController,
                      onChanged: (final String height) {
                        vars = vars.copyWith(
                          height: () => double.tryParse(height) ?? 0,
                        );
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: "Height",
                        prefixIcon: Icon(Icons.swap_vert_rounded),
                      ),
                      validator: _numericValidator(
                        "please enter the robot's height",
                      ),
                    ),
                    SectionDivider(label: "OnStage"),
                    const SizedBox(
                      height: 20,
                    ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Switcher(
                      borderRadiusGeometry: defaultBorderRadius,
                      selected: vars.hasBuddyClimb.mapNullable(
                            (final bool canBuddyClimb) => canBuddyClimb ? 1 : 0,
                          ) ??
                          -1,
                      labels: const <String>[
                        "Can't Buddy Climb",
                        "Can Buddy Climb",
                      ],
                      colors: const <Color>[
                        Colors.white,
                        Colors.white,
                      ],
                      onChange: (final int selection) {
                        setState(() {
                          vars = vars.copyWith(
                            hasBuddyClimb: () =>
                                <int, bool>{1: true, 0: false}[selection],
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
                        vars = vars.copyWith(
                          notes: () => notes,
                        );
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
          mutation InsertPit(
              $url: String,
              $drive_motor_amount: Int,
              $drivemotor_id: Int,
              $drivetrain_id: Int,
              $wheel_type_id: Int,
              $other_wheel_type: String,
              $gearbox_purchased: Boolean,
              $notes:String,
              $has_shifter:Boolean,
              $team_id:Int,
              $weight:Int,
              $height: Int,
              $harmonize: Boolean,
              $trap: Int,
              $has_buddy_climb: Boolean,
              ) {
          insert_pit(objects: {
          url: $url,
          drive_motor_amount: $drive_motor_amount,
          drivemotor_id: $drivemotor_id,
          drivetrain_id: $drivetrain_id,
          wheel_type_id: $wheel_type_id,
          other_wheel_type: $other_wheel_type,
          gearbox_purchased: $gearbox_purchased,
          notes: $notes,
          has_shifter: $has_shifter,
          team_id: $team_id,
          weight:  $weight,
          height: $height,
          harmony: $harmonize,
          trap: $trap,
          has_buddy_climb: $has_buddy_climb,
          }) {
              returning {
                url
              }
          }
          }
          """;

const String updateMutation = r"""
          mutation UpdatePit(
              $drive_motor_amount: Int,
              $drivemotor_id: Int,
              $drivetrain_id: Int,
              $wheel_type_id: Int,
              $other_wheel_type: String,
              $gearbox_purchased: Boolean,
              $notes:String,
              $has_shifter:Boolean,
              $team_id:Int,
              $weight:Int,
              $height: Int,
              $harmony: Boolean,
              $trap: Int,
              $has_buddy_climb: Boolean,
              ) {
          update_pit(where: {team_id: {_eq: $team_id}}, _set: {
          drive_motor_amount: $drive_motor_amount,
          drivemotor_id: $drivemotor_id,
          drivetrain_id: $drivetrain_id,
          wheel_type_id: $wheel_type_id
          other_wheel_Type: $other_wheel_type,
          gearbox_purchased: $gearbox_purchased,
          notes: $notes,
          has_shifter: $has_shifter,
          team_id: $team_id,
          weight:  $weight,
          height: $height,
          harmony: $harmonize,
          trap: $trap
          has_buddy_climb: $has_buddy_climb,
          }) {
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

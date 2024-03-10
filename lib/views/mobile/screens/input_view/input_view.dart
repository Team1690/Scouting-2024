import "dart:async";
import "dart:convert";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/input_view_vars.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/local_save_button.dart";
import "package:scouting_frontend/views/mobile/manage_preferences.dart";
import "package:scouting_frontend/views/mobile/qr_generator.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/climbing.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/game_piece_counter.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/trap_amount.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/traps_missed.dart";
import "package:scouting_frontend/views/mobile/screens/robot_image.dart";
import "package:scouting_frontend/views/mobile/screens/scouter_name_input.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/mobile/submit_button.dart";
import "package:scouting_frontend/views/mobile/team_and_match_selection.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/match_mode_enum.dart";

class UserInput extends StatefulWidget {
  const UserInput([this.initialVars]);
  final InputViewVars? initialVars;
  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  void flickerScreen(final int newValue, final int oldValue) {
    if (!toggleLightsState) return;
    screenColor = oldValue > newValue
        ? Colors.red
        : oldValue < newValue
            ? Colors.green
            : null;

    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        screenColor = null;
      });
    });
  }

  Color? screenColor;

  final TextEditingController matchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> jsonFormKey = GlobalKey();
  final TextEditingController teamNumberController = TextEditingController();
  final TextEditingController scouterNameController = TextEditingController();
  bool toggleLightsState = false;
  late InputViewVars match = InputViewVars(context);
  // -1 means nothing
  late final Map<int, int> robotFieldStatusIndexToId = <int, int>{
    -1: IdProvider.of(context).robotFieldStatus.nameToId["Worked"]!,
    0: IdProvider.of(context)
        .robotFieldStatus
        .nameToId["Didn't come to field"]!,
    1: IdProvider.of(context)
        .robotFieldStatus
        .nameToId["Didn't work on field"]!,
    2: IdProvider.of(context).robotFieldStatus.nameToId["Did Defence"]!,
  };
  String qrCodeJson = "";

  bool initialFlag = false;

  void updateTextFields() {
    matchController.text =
        "${match.scheduleMatch!.matchIdentifier.type.title} ${match.scheduleMatch!.matchIdentifier.number}";
    teamNumberController.text = <String>[
      "Practice",
      "Pre scouting",
    ].contains(match.scheduleMatch!.matchIdentifier.type.title)
        ? "${match.scoutedTeam!.number} ${match.scoutedTeam!.name}"
        : match.scheduleMatch!.getTeamStation(match.scoutedTeam!) ?? "";
    scouterNameController.text = match.scouterName!;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.initialVars != null) {
        match = widget.initialVars!;
        updateTextFields();
      }
    });
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: isPC(context) ? null : SideNavBar(),
        appBar: AppBar(
          actions: <Widget>[
            RobotImageButton(teamId: () => match.scoutedTeam?.id),
            ToggleButtons(
              children: const <Icon>[Icon(Icons.lightbulb)],
              isSelected: <bool>[toggleLightsState],
              onPressed: (final int i) {
                setState(() {
                  toggleLightsState = !toggleLightsState;
                });
              },
              renderBorder: false,
            ),
            IconButton(
              onPressed: () async {
                (await showDialog(
                  context: context,
                  builder: (final BuildContext dialogContext) =>
                      ManagePreferences(
                    mutation: widget.initialVars == null
                        ? insertMutation
                        : updateMutation,
                  ),
                ));
              },
              icon: const Icon(Icons.storage_rounded),
            ),
          ],
          centerTitle: true,
          elevation: 5,
          title: const Text(
            "Orbit Scouting",
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: <Widget>[
                      ScouterNameInput(
                        onScouterNameChange: (final String scouterName) {
                          match =
                              match.copyWith(scouterName: always(scouterName));
                        },
                        scouterNameController: scouterNameController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TeamAndMatchSelection(
                        matchController: matchController,
                        teamNumberController: teamNumberController,
                        onChange: (
                          final ScheduleMatch selectedMatch,
                          final LightTeam? team,
                        ) {
                          setState(() {
                            match = match.copyWith(
                              scheduleMatch: always(selectedMatch),
                              scoutedTeam: always(team),
                            );
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
                        isSelected: <bool>[match.isRematch],
                        onPressed: (final int i) {
                          setState(() {
                            match = match.copyWith(
                              isRematch: always(!match.isRematch),
                            );
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SectionDivider(label: "Autonomous"),
                      MatchModeGamePieceCounter(
                        flickerScreen: flickerScreen,
                        match: match,
                        onNewMatch: (final InputViewVars match) {
                          setState(() {
                            this.match = match;
                          });
                        },
                        matchMode: MatchMode.auto,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SectionDivider(label: "Teleoperated"),
                      MatchModeGamePieceCounter(
                        flickerScreen: flickerScreen,
                        match: match,
                        onNewMatch: (final InputViewVars match) {
                          setState(() {
                            this.match = match;
                          });
                        },
                        matchMode: MatchMode.tele,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ToggleButtons(
                            fillColor: const Color.fromARGB(10, 244, 67, 54),
                            selectedColor: Colors.purple,
                            selectedBorderColor: Colors.purple,
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("Defence"),
                              ),
                            ],
                            isSelected: <bool>[match.isDefence],
                            onPressed: (final int i) {
                              setState(() {
                                match = match.copyWith(
                                  isDefence: always(!match.isDefence),
                                );
                              });
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ToggleButtons(
                            fillColor: const Color.fromARGB(10, 244, 67, 54),
                            selectedColor: Colors.purple,
                            selectedBorderColor: Colors.purple,
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("Delivery"),
                              ),
                            ],
                            isSelected: <bool>[match.isDeliverd],
                            onPressed: (final int i) {
                              setState(() {
                                match = match.copyWith(
                                  isDeliverd: always(!match.isDeliverd),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Climbing(
                        match: match,
                        onNewMatch: (final InputViewVars newMatch) {
                          setState(() {
                            match = newMatch;
                          });
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: TrapAmount(
                              onTrapChange: (final int trap) {
                                setState(() {
                                  match =
                                      match.copyWith(trapAmount: always(trap));
                                });
                              },
                              match: match,
                              flickerScreen: flickerScreen,
                            ),
                          ),
                          const VerticalDivider(),
                          Expanded(
                            child: TrapsMissed(
                              onTrapChange: (final int trap) {
                                setState(() {
                                  match =
                                      match.copyWith(trapsMissed: always(trap));
                                });
                              },
                              flickerScreen: flickerScreen,
                              match: match,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SectionDivider(label: "Robot fault"),
                      Switcher(
                        borderRadiusGeometry: defaultBorderRadius,
                        labels: const <String>[
                          "Not on field",
                          "Didn't work on field",
                          "Did Defence",
                        ],
                        colors: const <Color>[
                          Colors.red,
                          Color.fromARGB(255, 198, 29, 228),
                          Colors.blue,
                        ],
                        onChange: (final int i) {
                          setState(() {
                            match = match.copyWith(
                              robotFieldStatusId:
                                  always(robotFieldStatusIndexToId[i]!),
                            );
                          });
                        },
                        selected: <int, int>{
                          for (final MapEntry<int, int> i
                              in robotFieldStatusIndexToId.entries)
                            i.value: i.key,
                        }[match.robotFieldStatusId]!,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SubmitButton(
                        resetForm: () {
                          setState(() {
                            match = match.cleared(context);
                            teamNumberController.clear();
                            matchController.clear();
                          });
                        },
                        validate: () => formKey.currentState!.validate(),
                        getJson: match.toJson,
                        mutation: widget.initialVars == null
                            ? insertMutation
                            : updateMutation,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundedIconButton(
                        color: Colors.green,
                        onPress: () async {
                          if (formKey.currentState!.validate()) {
                            (await showDialog(
                              context: context,
                              builder: (final BuildContext dialogContext) =>
                                  QRGenerator(jsonData: jsonEncode(match)),
                            ));
                          }
                        },
                        onLongPress: () async {
                          (await showDialog(
                            context: context,
                            builder: (final BuildContext dialogContext) =>
                                SizedBox(
                              width: 100,
                              child: AlertDialog(
                                content: Form(
                                  key: jsonFormKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFormField(
                                        validator:
                                            (final String? pastedString) =>
                                                pastedString == null ||
                                                        pastedString.isEmpty
                                                    ? "Please paste a code"
                                                    : null,
                                        onChanged:
                                            (final String pastedString) =>
                                                setState(() {
                                          qrCodeJson = pastedString;
                                        }),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Enter Match Data",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      SubmitButton(
                                        getJson: () {
                                          try {
                                            return jsonDecode(qrCodeJson)
                                                as Map<String, dynamic>;
                                          } on Exception {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Center(
                                                  child: Text(
                                                    "Invalid Code",
                                                  ),
                                                ),
                                              ),
                                            );
                                            return <String, dynamic>{};
                                          }
                                        },
                                        mutation: widget.initialVars == null
                                            ? insertMutation
                                            : updateMutation,
                                        resetForm: () => qrCodeJson = "",
                                        validate: () => jsonFormKey
                                            .currentState!
                                            .validate(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));
                        },
                        icon: Icons.qr_code_2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      LocalSaveButton(
                        vars: match,
                        mutation: widget.initialVars == null
                            ? insertMutation
                            : updateMutation,
                        resetForm: () {
                          setState(() {
                            match = match.cleared(context);
                            teamNumberController.clear();
                            matchController.clear();
                          });
                        },
                        validate: () => formKey.currentState!.validate(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (screenColor != null)
              Container(
                color: screenColor,
              ),
          ],
        ),
      );

  String insertMutation = r"""
mutation MyMutation($auto_amp: Int!, $auto_amp_missed: Int!, $auto_speaker: Int!, $auto_speaker_missed: Int!, $climb_id: Int!, $tele_amp: Int!, $tele_amp_missed: Int!, $tele_speaker: Int!, $tele_speaker_missed: Int!, $trap_amount: Int!, $traps_missed: Int!, $harmony_with: Int!, $is_rematch: Boolean!, $robot_field_status_id: Int, $schedule_id: Int!, $team_id: Int!, $scouter_name: String!) {
  insert_technical_match(objects: {auto_amp: $auto_amp, auto_amp_missed: $auto_amp_missed, auto_speaker: $auto_speaker, auto_speaker_missed: $auto_speaker_missed, cilmb_id: $climb_id, tele_amp: $tele_amp, tele_amp_missed: $tele_amp_missed, tele_speaker: $tele_speaker, tele_speaker_missed: $tele_speaker_missed, trap_amount: $trap_amount, traps_missed: $traps_missed, harmony_with: $harmony_with, is_rematch: $is_rematch, robot_field_status_id: $robot_field_status_id, schedule_id: $schedule_id, team_id: $team_id, scouter_name: $scouter_name}) {
    affected_rows
  }
}

""";

  String updateMutation = r"""
mutation MyMutation($auto_amp: Int!, $auto_amp_missed: Int!, $auto_speaker: Int!, $auto_speaker_missed: Int!, $climb_id: Int!, $tele_amp: Int!, $tele_amp_missed: Int!, $tele_speaker: Int!, $tele_speaker_missed: Int!, $trap_amount: Int!, $traps_missed: Int!, $harmony_with: Int!, $is_rematch: Boolean!, $robot_field_status_id: Int, $schedule_id: Int!, $team_id: Int!, $scouter_name: String!) {
  update_technical_match(where: {team_id: {_eq: $team_id}, schedule_id: {_eq: $schedule_id}, is_rematch: {_eq: $is_rematch}} _set: {auto_amp: $auto_amp, auto_amp_missed: $auto_amp_missed, auto_speaker: $auto_speaker, auto_speaker_missed: $auto_speaker_missed, cilmb_id: $climb_id, tele_amp: $tele_amp, tele_amp_missed: $tele_amp_missed, tele_speaker: $tele_speaker, tele_speaker_missed: $tele_speaker_missed, trap_amount: $trap_amount, traps_missed: $traps_missed, harmony_with: $harmony_with, is_rematch: $is_rematch, robot_field_status_id: $robot_field_status_id, schedule_id: $schedule_id, team_id: $team_id, scouter_name: $scouter_name}) {
    affected_rows
  }
}
""";
}

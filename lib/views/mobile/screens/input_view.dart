import "dart:async";
import "dart:convert";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/id_providers.dart";

import "package:scouting_frontend/models/match_model.dart";
import "package:scouting_frontend/models/matches_model.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/local_save_button.dart";
import "package:scouting_frontend/views/mobile/manage_preferences.dart";
import "package:scouting_frontend/views/mobile/qr_generator.dart";
import "package:scouting_frontend/views/mobile/screens/robot_image.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/mobile/submit_button.dart";
import "package:scouting_frontend/views/mobile/team_and_match_selection.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class UserInput extends StatefulWidget {
  const UserInput([this.initialVars]);
  final Match? initialVars;
  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  void flickerScreen(final int newValue, final int oldValue) {
    screenColor = oldValue > newValue && toggleLightsState
        ? Colors.red
        : oldValue < newValue && toggleLightsState
            ? Colors.green
            : null;

    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        screenColor = null;
      });
    });
  }

  // Widget _gamePieceCounters(final CounterSpec spec) => Counter(
  //       plus: spec.plus,
  //       minus: spec.minus,
  //       label: spec.label,
  //       icon: spec.icon,
  //       onChange: (final int count) {
  //         setState(() {
  //           flickerScreen(
  //             count,
  //             spec.getValues(),
  //           );
  //           spec.updateValues(count);
  //         });
  //       },
  //       count: spec.getValues(),
  //     );

  Color? screenColor;

  final TextEditingController matchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> jsonFormKey = GlobalKey();
  final TextEditingController teamNumberController = TextEditingController();
  final TextEditingController scouterNameController = TextEditingController();
  bool toggleLightsState = false;
  late Match match = Match(
    robotMatchStatusId:
        IdProvider.of(context).robotMatchStatus.nameToId["Worked"] as int,
  );
  // -1 means nothing
  late final Map<int, int> robotMatchStatusIndexToId = <int, int>{
    -1: IdProvider.of(context).robotMatchStatus.nameToId["Worked"]!,
    0: IdProvider.of(context)
        .robotMatchStatus
        .nameToId["Didn't come to field"]!,
    1: IdProvider.of(context)
        .robotMatchStatus
        .nameToId["Didn't work on field"]!,
  };
  String qrCodeJson = "";

  bool initialFlag = false;

  @override
  Widget build(final BuildContext context) {
    if (widget.initialVars != null && initialFlag == false) {
      setState(() {
        match = widget.initialVars!;
        matchController.text =
            "${IdProvider.of(context).matchType.idToName[match.scheduleMatch!.matchTypeId]} ${match.scheduleMatch!.matchNumber}";
        teamNumberController.text = <int?>[
          IdProvider.of(context).matchType.nameToId["Practice"],
          IdProvider.of(context).matchType.nameToId["Pre scouting"],
        ].contains(match.scheduleMatch!.matchTypeId)
            ? "${match.scoutedTeam!.number} ${match.scoutedTeam!.name}"
            : match.scheduleMatch!.getTeamStation(match.scoutedTeam!) ?? "";
        scouterNameController.text = match.name!;
        initialFlag = true;
      });
    }
    final Map<int, String> startingPosProvider =
        IdProvider.of(context).startingPositionIds.idToName;
    final int notOnFieldId = IdProvider.of(context)
        .robotMatchStatus
        .nameToId["Didn't come to field"]!;
    return Scaffold(
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
                  mutation:
                      widget.initialVars == null ? mutation : updateMutation,
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
                    TextFormField(
                      controller: scouterNameController,
                      validator: (final String? value) =>
                          value != null && value.isNotEmpty
                              ? null
                              : "Please enter your name",
                      onChanged: (final String name) {
                        match.name = name;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        hintText: "Scouter name",
                      ),
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
                          match.scheduleMatch = selectedMatch;
                          match.scoutedTeam = team ?? match.scoutedTeam;
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
                          match.isRematch = !match.isRematch;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: match.robotMatchStatusId != notOnFieldId,
                      child: Column(
                        children: <Widget>[
                          SectionDivider(label: "Robot Placement"),
                          const SizedBox(
                            height: 15,
                          ),
                          Selector<int>(
                            options: startingPosProvider.keys.toList(),
                            placeholder: "Choose a starting position",
                            value: match.startingPositionId,
                            makeItem: (final int index) =>
                                startingPosProvider[index]!,
                            onChange: ((final int currentValue) =>
                                match.startingPositionId = currentValue),
                            validate: (final int? submmission) =>
                                match.robotMatchStatusId == notOnFieldId
                                    ? null
                                    : submmission.onNull(
                                        "Please pick a starting position",
                                      ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    SectionDivider(label: "Autonomous"),
                    //TODO Auto related widgets here

                    // Visibility(
                    //   visible: match.robotMatchStatusId != notOnFieldId,
                    //   child: ToggleButtons(
                    //     fillColor: const Color.fromARGB(10, 244, 67, 54),
                    //     selectedColor: Colors.green,
                    //     selectedBorderColor: Colors.green,
                    //     children: const <Widget>[
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 10),
                    //         child: Text("Mobility"),
                    //       ),
                    //     ],
                    //     isSelected: <bool>[match.mobility],
                    //     onPressed: (final int i) {
                    //       setState(() {
                    //         match.mobility = !match.mobility;
                    //       });
                    //     },
                    //   ),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    SectionDivider(label: "Teleoperated"),
                    //TODO teleop related widgets here
                    const SizedBox(
                      height: 20,
                    ),
                    SectionDivider(label: "Robot fault"),
                    Switcher(
                      borderRadiusGeometry: defaultBorderRadius,
                      labels: const <String>[
                        "Not on field",
                        "Didn't work on field",
                      ],
                      colors: const <Color>[
                        Colors.red,
                        Color.fromARGB(255, 198, 29, 228),
                      ],
                      onChange: (final int i) {
                        setState(() {
                          match.robotMatchStatusId =
                              robotMatchStatusIndexToId[i]!;
                        });
                      },
                      selected: <int, int>{
                        for (final MapEntry<int, int> i
                            in robotMatchStatusIndexToId.entries)
                          i.value: i.key,
                      }[match.robotMatchStatusId]!,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SubmitButton(
                      resetForm: () {
                        setState(() {
                          match.clear(context);
                          teamNumberController.clear();
                          matchController.clear();
                        });
                      },
                      validate: () => formKey.currentState!.validate(),
                      getJson: match.toJson,
                      mutation: widget.initialVars == null
                          ? mutation
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
                                      validator: (final String? pastedString) =>
                                          pastedString == null ||
                                                  pastedString.isEmpty
                                              ? "Please paste a code"
                                              : null,
                                      onChanged: (final String pastedString) =>
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
                                          ? mutation
                                          : updateMutation,
                                      resetForm: () => qrCodeJson = "",
                                      validate: () =>
                                          jsonFormKey.currentState!.validate(),
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
                          ? mutation
                          : updateMutation,
                      resetForm: () {
                        setState(() {
                          match.clear(context);
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
  }
}

//TODO update both mutations
const String mutation = r"""

""";

const String updateMutation = r"""

""";

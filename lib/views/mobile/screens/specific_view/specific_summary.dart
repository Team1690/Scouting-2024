import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_summary_text_field.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";

class SpecificSummary extends StatefulWidget {
  const SpecificSummary({super.key});

  @override
  State<SpecificSummary> createState() => _SpecificSummaryState();
}

class _SpecificSummaryState extends State<SpecificSummary> {
  final TextEditingController teamSelectionController = TextEditingController();
  final TextEditingController ampController = TextEditingController();
  final TextEditingController climbController = TextEditingController();
  final TextEditingController drivingController = TextEditingController();
  final TextEditingController generalController = TextEditingController();
  final TextEditingController intakeController = TextEditingController();
  final TextEditingController speakerController = TextEditingController();
  bool isEnabled = false;
  bool isPressed = false;
  @override
  Widget build(final BuildContext context) => Scaffold(
        drawer: isPC(context) ? null : SideNavBar(),
        appBar: AppBar(
          actions: const <Widget>[],
          centerTitle: true,
          elevation: 5,
          title: const Text(
            "Specific Summary",
          ),
        ),
        body: CarouselWithIndicator(
          widgets: <Widget>[
            const Text("text"),
            Column(
              children: <Widget>[
                TeamSelectionFuture(
                  onChange: (final LightTeam lightTeam) {
                    setState(() {
                      isPressed = true;
                    });
                  },
                  controller: teamSelectionController,
                ),
                TextButton(
                  onPressed: () {
                    isPressed ? setState(() => isEnabled = true) : null;
                  },
                  child: const Text("Edit"),
                ),
                SpecificSummaryTextField(
                  onTextChanged: () {
                    setState(() {
                      isEnabled = false;
                    });
                  },
                  isEnabled: isEnabled,
                  controller: ampController,
                  label: "Amp",
                ),
                SpecificSummaryTextField(
                  onTextChanged: () {
                    setState(() {
                      isEnabled = false;
                    });
                  },
                  isEnabled: isEnabled,
                  controller: speakerController,
                  label: "Speaker",
                ),
                SpecificSummaryTextField(
                  onTextChanged: () {
                    setState(() {
                      isEnabled = false;
                    });
                  },
                  isEnabled: isEnabled,
                  controller: climbController,
                  label: "Intake",
                ),
                SpecificSummaryTextField(
                  onTextChanged: () {
                    setState(() {
                      isEnabled = false;
                    });
                  },
                  isEnabled: isEnabled,
                  controller: drivingController,
                  label: "Climing",
                ),
                SpecificSummaryTextField(
                  onTextChanged: () {
                    setState(() {
                      isEnabled = false;
                    });
                  },
                  isEnabled: isEnabled,
                  controller: intakeController,
                  label: "General",
                ),
                SpecificSummaryTextField(
                  onTextChanged: () {
                    setState(() {
                      isEnabled = false;
                    });
                  },
                  isEnabled: isEnabled,
                  controller: generalController,
                  label: "Driving",
                ),
              ],
            ),
          ],
        ),
      );

  String updateMutation = r"""
mutation MyMutation(
  $amp_text: String_comparison_exp, 
  $climb_text: String_comparison_exp, 
  $driving_text: String_comparison_exp, 
  $general_text: String_comparison_exp, 
  $intake_text: String_comparison_exp, 
  $speaker_text: String_comparison_exp
  ){
  update_specific_summary(
    where: {
      amp_text: $amp_text, 
      climb_text: $climb_text, 
      driving_text: $driving_text, 
      general_text: $general_text, 
      intake_text: $intake_text, 
      speaker_text: $speaker_text
      }){
    affected_rows
  }
""";

  String subSciriptionMutation = r"""
subscription MySubscription {
  specific_summary {
    amp_text
    climb_text
    driving_text
    general_text
    intake_text
    speaker_text
  }
}
""";
}

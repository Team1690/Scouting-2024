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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TeamSelectionFuture(
                  onChange: (final LightTeam lightTeam) {},
                  controller: teamSelectionController,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEnabled = true;
                        });
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
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  String insertMutation = r"""
mutation MyMutation($amp_text: String, $climb_text: String, $driving_text: String, $general_text: String, $intake_text: String, $speaker_text: String) {
  insert_specific_summary(objects: {amp_text: $amp_text, climb_text: $climb_text, driving_text: $driving_text, general_text: $general_text, intake_text: $intake_text, speaker_text: $speaker_text}) {
    affected_rows
  }
}

""";

  String updateMutation = r"""

""";
  String subSciriptionMutation = r"""

""";
}

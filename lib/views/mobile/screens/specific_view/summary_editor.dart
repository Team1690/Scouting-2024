import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_model.dart";
import 'package:scouting_frontend/views/mobile/screens/specific_view/specific_summary_card.dart';
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_summary_text_field.dart";
import "package:scouting_frontend/views/mobile/submit_button.dart";

class SummaryEditor extends StatefulWidget {
  const SummaryEditor({
    super.key,
    required this.summaryEntry,
    required this.team,
  });
  final SummaryEntry? summaryEntry;
  final LightTeam team;
  @override
  State<SummaryEditor> createState() => _SummaryEditorState();
}

class _SummaryEditorState extends State<SummaryEditor> {
  @override
  void initState() {
    updateTextFields();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final SummaryEditor oldWidget) {
    updateTextFields();
    super.didUpdateWidget(oldWidget);
  }

  void updateTextFields() {
    ampController.text = widget.summaryEntry?.ampText ?? "";
    speakerController.text = widget.summaryEntry?.speakerText ?? "";
    intakeController.text = widget.summaryEntry?.intakeText ?? "";
    generalController.text = widget.summaryEntry?.generalText ?? "";
    climbController.text = widget.summaryEntry?.climbText ?? "";
    drivingController.text = widget.summaryEntry?.drivingText ?? "";
  }

  bool isEnabled = false;
  final TextEditingController ampController = TextEditingController();
  final TextEditingController climbController = TextEditingController();
  final TextEditingController drivingController = TextEditingController();
  final TextEditingController generalController = TextEditingController();
  final TextEditingController intakeController = TextEditingController();
  final TextEditingController speakerController = TextEditingController();
  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    isEnabled = true;
                  });
                },
                child: const Text("Edit"),
              ),
              SubmitButton(
                getJson: () => <String, dynamic>{
                  "team_id": widget.team.id,
                  "amp_text": ampController.text,
                  "speaker_text": speakerController.text,
                  "climb_text": climbController.text,
                  "driving_text": drivingController.text,
                  "general_text": generalController.text,
                  "intake_text": intakeController.text,
                },
                mutation: widget.summaryEntry == null
                    ? _insertMutation
                    : _updateMutation,
                resetForm: () {},
                validate: () => true,
              ),
            ],
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
            controller: intakeController,
            label: "Intake",
          ),
          SpecificSummaryTextField(
            onTextChanged: () {
              setState(() {
                isEnabled = false;
              });
            },
            isEnabled: isEnabled,
            controller: climbController,
            label: "Climbing",
          ),
          SpecificSummaryTextField(
            onTextChanged: () {
              setState(() {
                isEnabled = false;
              });
            },
            isEnabled: isEnabled,
            controller: generalController,
            label: "General",
          ),
          SpecificSummaryTextField(
            onTextChanged: () {
              setState(() {
                isEnabled = false;
              });
            },
            isEnabled: isEnabled,
            controller: drivingController,
            label: "Driving",
          ),
        ],
      );
}

const String _insertMutation = """
  mutation MyMutation(
    \$amp_text: String, 
    \$climb_text: String, 
    \$driving_text: String, 
    \$general_text: String, 
    \$intake_text: String, 
    \$speaker_text: String, 
    \$team_id: Int) {
  insert_specific_summary(
    objects: {
      amp_text: \$amp_text, 
      climb_text: \$climb_text, 
      driving_text: \$driving_text, 
      general_text: \$general_text, 
      intake_text: \$intake_text, 
      speaker_text: \$speaker_text, 
      team_id: \$team_id}) {
    affected_rows
  }
}

""";

const String _updateMutation = """
mutation MyMutation(\$team_id: Int, \$amp_text: String, \$climb_text: String, \$driving_text: String, \$general_text: String, \$intake_text: String, \$speaker_text: String) {
  update_specific_summary(where: {team_id: {_eq: \$team_id}}, _set: {amp_text: \$amp_text, climb_text: \$climb_text, driving_text: \$driving_text, general_text: \$general_text, intake_text: \$intake_text, speaker_text: \$speaker_text}) {
    affected_rows
  }
}
""";

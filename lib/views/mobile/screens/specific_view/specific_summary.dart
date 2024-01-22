import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
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
  int teamId = 0;
  String? intakeText;
  String? climbText;
  String? drivingText;
  String? ampText;
  String? speakerText;
  String? generalText;
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
        body: StreamBuilder<List<String>>(
          stream: null,
          builder: (
            final BuildContext context,
            final AsyncSnapshot<List<String>> snapshot,
          ) =>
              CarouselWithIndicator(
            widgets: <Widget>[
              const Text("text"),
              Column(
                children: <Widget>[
                  TeamSelectionFuture(
                    onChange: (final LightTeam lightTeam) {
                      setState(() {
                        teamId = lightTeam.id;
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
                        ampText = ampController.text;
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
                        speakerText = speakerController.text;
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
                        intakeText = intakeController.text;
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
                        climbText = climbController.text;
                      });
                    },
                    isEnabled: isEnabled,
                    controller: drivingController,
                    label: "Climbing",
                  ),
                  SpecificSummaryTextField(
                    onTextChanged: () {
                      setState(() {
                        isEnabled = false;
                        generalText = generalController.text;
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
                        drivingText = drivingController.text;
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
        ),
      );

  Future<QueryResult<void>> addSpecificSummary(
    final int teamId,
    final String? intakeText,
    final String? climbText,
    final String? drivingText,
    final String? ampText,
    final String? speakerText,
    final String? generalText,
  ) =>
      getClient().mutate(
        MutationOptions<void>(
          document: gql(insertMutation),
          variables: <String, dynamic>{
            "team_id": teamId,
            "intake_text": intakeText,
            "general_text": generalText,
            "amp_text": ampText,
            "climb_text": climbText,
            "driving_text": drivingText,
            "speaker_text": speakerText,
          },
        ),
      );
  String insertMutation = """
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

  Stream<SummaryEntry> fetchSpecificSummary() {
    const String subScriptionMutation = """
      subscription MySubscription(\$team_id: Int) {
        specific_summary(where: {team_id: {_eq: \$team_id}}) {
          amp_text
          climb_text
          driving_text
          general_text
          intake_text
          speaker_text
        }
      }
""";

    final GraphQLClient client = getClient();
    final Stream<QueryResult<SummaryEntry>> result = client.subscribe(
      SubscriptionOptions<SummaryEntry>(
        document: gql(subScriptionMutation),
        parserFn: (final Map<String, dynamic> data) => SummaryEntry(
          data["specific_summary"]["intake_text"] as String,
          data["specific_summary"]["amp_text"] as String,
          data["specific_summary"]["climb_text"] as String,
          data["specific_summary"]["driving_text"] as String,
          data["specific_summary"]["speaker_text"] as String,
          data["specific_summary"]["general_text"] as String,
        ),
      ),
    );
    return result.map(queryResultToParsed);
  }

  Future<QueryResult<void>> updateFaultStatus(
    final String? intakeText,
    final String? climbText,
    final String? drivingText,
    final String? ampText,
    final String? speakerText,
    final String? generalText,
  ) async =>
      getClient().mutate(
        MutationOptions<void>(
          document: gql(updateMutation),
          variables: <String, dynamic>{
            "intake_text": intakeText,
            "general_text": generalText,
            "amp_text": ampText,
            "climb_text": climbText,
            "driving_text": drivingText,
            "speaker_text": speakerText,
          },
        ),
      );

  String updateMutation = """
mutation MyMutation(\$team_id: Int, \$amp_text: String, \$climb_text: String, \$driving_text: String, \$general_text: String, \$intake_text: String, \$speaker_text: String) {
  update_specific_summary(where: {team_id: {_eq: \$team_id}}, _set: {amp_text: \$amp_text, climb_text: \$climb_text, driving_text: \$driving_text, general_text: \$general_text, intake_text: \$intake_text, speaker_text: \$speaker_text}) {
    affected_rows
  }
}
""";
}

class SummaryEntry {
  const SummaryEntry(
    this.intakeText,
    this.climbText,
    this.drivingText,
    this.ampText,
    this.speakerText,
    this.generalText,
  );
  final String? intakeText;
  final String? climbText;
  final String? drivingText;
  final String? ampText;
  final String? speakerText;
  final String? generalText;
}

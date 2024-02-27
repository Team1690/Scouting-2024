import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/summary_editor.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";

// ignore: must_be_immutable
class SpecificSummaryCard extends StatefulWidget {
  SpecificSummaryCard({super.key, required this.team});
  LightTeam? team;
  @override
  State<SpecificSummaryCard> createState() => _SpecificSummaryCardState();
}

class _SpecificSummaryCardState extends State<SpecificSummaryCard> {
  late TextEditingController teamSelectionController = TextEditingController(
    text: "${widget.team?.number} ${widget.team?.name}",
  );

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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TeamSelectionFuture(
                teams: TeamProvider.of(context).teams,
                onChange: (final LightTeam lightTeam) {
                  setState(() {
                    widget.team = lightTeam;
                  });
                },
                controller: teamSelectionController,
              ),
              if (widget.team != null)
                StreamBuilder<SummaryEntry?>(
                  stream: fetchSpecificSummary(widget.team!.id),
                  builder: (
                    final BuildContext context,
                    final AsyncSnapshot<SummaryEntry?> snapshot,
                  ) =>
                      snapshot.mapSnapshot(
                    onSuccess: (final SummaryEntry? summaryEntry) =>
                        SummaryEditor(
                      summaryEntry: summaryEntry,
                      team: widget.team!,
                    ),
                    onWaiting: CircularProgressIndicator.new,
                    onNoData: () =>
                        SummaryEditor(summaryEntry: null, team: widget.team!),
                    onError: (final Object error) => Text("$error"),
                  ),
                ),
            ],
          ),
        ),
      );
}

const String specificSummarySubscription = """
      subscription MySubscription(\$team_id: Int) {
        specific_summary(where: {team_id: {_eq: \$team_id}}) {
          amp_text
          climb_text
          driving_text
          general_text
          intake_text
          speaker_text
          defense_text
        }
      }
""";

Stream<SummaryEntry?> fetchSpecificSummary(
  final int teamId,
) {
  final GraphQLClient client = getClient();
  final Stream<QueryResult<SummaryEntry?>> result = client.subscribe(
    SubscriptionOptions<SummaryEntry?>(
      document: gql(specificSummarySubscription),
      variables: <String, dynamic>{"team_id": teamId},
      parserFn: (final Map<String, dynamic> data) {
        final List<dynamic> specificSummary =
            data["specific_summary"] as List<dynamic>;
        if (specificSummary.isEmpty) {
          return null;
        }
        return SummaryEntry(
          intakeText: specificSummary[0]["intake_text"] as String,
          ampText: specificSummary[0]["amp_text"] as String,
          climbText: specificSummary[0]["climb_text"] as String,
          drivingText: specificSummary[0]["driving_text"] as String,
          speakerText: specificSummary[0]["speaker_text"] as String,
          generalText: specificSummary[0]["general_text"] as String,
          defenseText: specificSummary[0]["defense_text"] as String,
        );
      },
    ),
  );
  return result.map(
    (final QueryResult<SummaryEntry?> result) =>
        result.mapQueryResultNullable(),
  );
}

class SummaryEntry {
  const SummaryEntry({
    required this.defenseText,
    required this.intakeText,
    required this.climbText,
    required this.drivingText,
    required this.ampText,
    required this.speakerText,
    required this.generalText,
  });
  final String intakeText;
  final String climbText;
  final String drivingText;
  final String ampText;
  final String speakerText;
  final String generalText;
  final String defenseText;

  @override
  String toString() =>
      "$intakeText $climbText $drivingText $ampText $speakerText $generalText $defenseText";
}

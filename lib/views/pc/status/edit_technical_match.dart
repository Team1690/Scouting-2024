import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view.dart";

class EditTechnicalMatch extends StatelessWidget {
  const EditTechnicalMatch({
    required this.match,
    required this.teamForQuery,
  });
  final ScheduleMatch match;
  final LightTeam teamForQuery;

  @override
  Widget build(final BuildContext context) => isPC(context)
      ? DashboardScaffold(body: editTechnicalMatch(context))
      : Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(match.toString()),
          ),
          body: editTechnicalMatch(context),
        );
  FutureBuilder<InputViewVars> editTechnicalMatch(final BuildContext context) =>
      FutureBuilder<InputViewVars>(
        future: fetchTechnicalMatch(match, teamForQuery, context),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<InputViewVars> snapshot,
        ) =>
            snapshot.mapSnapshot(
          onSuccess: (final InputViewVars data) => UserInput(snapshot.data),
          onWaiting: () => const Center(
            child: CircularProgressIndicator(),
          ),
          onNoData: () => const Center(
            child: Text("No Data"),
          ),
          onError: (final Object error) => Center(
            child: Text(error.toString()),
          ),
        ),
      );
}

//TODO add new query here
const String query = r"""
query FetchTechnicalMatch($team_id: Int!, $match_type_id: Int!, $match_number: Int!, $is_rematch: Boolean!) {
  technical_match(where: {schedule_match: {match_type: {id: {_eq: $match_type_id}}, match_number: {_eq: $match_number}}, is_rematch: {_eq: $is_rematch}, team_id: {_eq: $team_id}}) {
    auto_amp
    auto_amp_missed
    auto_speaker
    auto_speaker_missed
    climb {
      id
    }
    harmony_with
    robot_field_status {
      id
    }
    scouter_name
    tele_amp
    tele_amp_missed
    tele_speaker
    tele_speaker_missed
    trap_amount
    traps_missed
    starting_position {
      id
    }
  }
}

""";

Future<InputViewVars> fetchTechnicalMatch(
  final ScheduleMatch scheduleMatch,
  final LightTeam teamForQuery,
  final BuildContext context,
) async {
  final GraphQLClient client = getClient();

  final QueryResult<InputViewVars> result = await client.query(
    QueryOptions<InputViewVars>(
      parserFn: (final Map<String, dynamic> data) {
        final dynamic technicalMatch = data["technical_match"][0];
        return InputViewVars.all(
          delivery: technicalMatch["delivery"] as int,
          trapsMissed: technicalMatch["traps_missed"] as int,
          isRematch: scheduleMatch.matchIdentifier.isRematch,
          scheduleMatch: scheduleMatch,
          scouterName: technicalMatch["scouter_name"] as String,
          robotFieldStatus: IdProvider.of(context)
              .robotFieldStatus
              .idToEnum[technicalMatch["robot_field_status"]["id"] as int]!,
          autoAmp: technicalMatch["auto_amp"] as int,
          autoAmpMissed: technicalMatch["auto_amp_missed"] as int,
          autoSpeaker: technicalMatch["auto_speaker"] as int,
          autoSpeakerMissed: technicalMatch["auto_speaker_missed"] as int,
          teleAmp: technicalMatch["tele_amp"] as int,
          teleAmpMissed: technicalMatch["tele_amp_missed"] as int,
          teleSpeaker: technicalMatch["tele_speaker"] as int,
          teleSpeakerMissed: technicalMatch["tele_speaker_missed"] as int,
          climb: IdProvider.of(context)
              .climb
              .idToEnum[technicalMatch["climb"]["id"] as int],
          harmonyWith: technicalMatch["harmony_with"] as int,
          trapAmount: technicalMatch["trap_amount"] as int,
          scoutedTeam: teamForQuery,
        );
      },
      document: gql(query),
      variables: <String, dynamic>{
        "team_id": teamForQuery.id,
        "match_type_id": IdProvider.of(context)
            .matchType
            .enumToId[scheduleMatch.matchIdentifier.type],
        "match_number": scheduleMatch.matchIdentifier.number,
        "is_rematch": scheduleMatch.matchIdentifier.isRematch,
      },
    ),
  );
  return result.mapQueryResult();
}

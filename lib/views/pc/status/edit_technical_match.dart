import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/autonomous/auto_gamepieces.dart";
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

//TODO add auto stuff
final String query = """
query FetchTechnicalMatch(\$team_id: Int!, \$match_type_id: Int!, \$match_number: Int!, \$is_rematch: Boolean!) {
  technical_match(where: {schedule_match: {match_type: {id: {_eq: \$match_type_id}}, match_number: {_eq: \$match_number}}, is_rematch: {_eq: \$is_rematch}, team_id: {_eq: \$team_id}}) {
    schedule_match {
        id
        match_type {
          id
        }
        match_number
        happened
      }
      is_rematch
      auto_order
      ${AutoGamepieceID.values.map((final AutoGamepieceID e) => '${e.title} { id }').join('\n')}
      R0_id
      L0_id
      L1_id
      L2_id
      M0_id
      M1_id
      M2_id
      M3_id
      M4_id
      tele_amp
      tele_amp_missed
      tele_speaker
      tele_speaker_missed
      trap_amount
      traps_missed
      delivery
      climb {
        id
        points
        title
      }
      robot_field_status {
        id
      }
      harmony_with
      scouter_name
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
          autoOrder: TechnicalMatchData.parseGamepieces(
            technicalMatch,
            IdProvider.of(context),
          )
              .map((final (AutoGamepieceID, AutoGamepieceState) e) => e.$1)
              .toList(),
          delivery: technicalMatch["delivery"] as int,
          trapsMissed: technicalMatch["traps_missed"] as int,
          isRematch: scheduleMatch.matchIdentifier.isRematch,
          scheduleMatch: scheduleMatch,
          scouterName: technicalMatch["scouter_name"] as String,
          robotFieldStatus: IdProvider.of(context)
              .robotFieldStatus
              .idToEnum[technicalMatch["robot_field_status"]["id"] as int]!,
          teleAmp: technicalMatch["tele_amp"] as int,
          teleAmpMissed: technicalMatch["tele_amp_missed"] as int,
          teleSpeaker: technicalMatch["tele_speaker"] as int,
          teleSpeakerMissed: technicalMatch["tele_speaker_missed"] as int,
          climb: IdProvider.of(context)
              .climb
              .idToEnum[technicalMatch["climb"]["id"] as int],
          harmonyWith: technicalMatch["harmony_with"] as int,
          trapAmount: technicalMatch["trap_amount"] as int,
          autoGamepieces: AutoGamepieces(
            r0: IdProvider.of(context)
                .autoGamepieceStates
                .idToEnum[technicalMatch["R0_id"] as int]!,
            l0: IdProvider.of(context)
                .autoGamepieceStates
                .idToEnum[technicalMatch["L0_id"] as int]!,
            l1: IdProvider.of(context)
                .autoGamepieceStates
                .idToEnum[technicalMatch["L1_id"] as int]!,
            l2: IdProvider.of(context)
                .autoGamepieceStates
                .idToEnum[technicalMatch["L2_id"] as int]!,
            m0: IdProvider.of(context)
                .autoGamepieceStates
                .idToEnum[technicalMatch["M0_id"] as int]!,
            m1: IdProvider.of(context)
                .autoGamepieceStates
                .idToEnum[technicalMatch["M1_id"] as int]!,
            m2: IdProvider.of(context)
                .autoGamepieceStates
                .idToEnum[technicalMatch["M2_id"] as int]!,
            m3: IdProvider.of(context)
                .autoGamepieceStates
                .idToEnum[technicalMatch["M3_id"] as int]!,
            m4: IdProvider.of(context)
                .autoGamepieceStates
                .idToEnum[technicalMatch["M4_id"] as int]!,
          ),
          scoutedTeam: teamForQuery,
          faultMessage: "",
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

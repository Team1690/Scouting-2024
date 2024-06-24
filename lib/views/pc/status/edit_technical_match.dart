import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view.dart";
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/blue_alliance_match_data.dart";

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

const String query = """
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
      tele_amp
      tele_amp_missed
      tele_speaker
      tele_speaker_missed
      auto_amp
      auto_amp_missed
      auto_speaker
      auto_speaker_missed
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
      autonomous_options {
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
          autonomousOptions: IdProvider.of(context)
              .autoOptions
              .idToEnum[technicalMatch["autonomous_options"]["id"] as int]!,
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
          autoAmp: technicalMatch["auto_amp"] as int,
          autoAmpMissed: technicalMatch["auto_amp_missed"] as int,
          autoSpeaker: technicalMatch["auto_speaker"] as int,
          autoSpeakerMissed: technicalMatch["auto_speaker_missed"] as int,
          climb: IdProvider.of(context)
              .climb
              .idToEnum[technicalMatch["climb"]["id"] as int],
          harmonyWith: technicalMatch["harmony_with"] as int,
          trapAmount: technicalMatch["trap_amount"] as int,
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

String subscription = """
subscription technical_matches {
  schedule_matches {
    technical_matches {
      auto_amp
      auto_speaker
      scouter_name
      tele_amp
      tele_speaker
    }
    match_number
  }
}
""";

Stream<List<(BlueAllianceMatchData, List<String>)>> fetchAlliancesMatch(
  final BuildContext context,
) =>
    getClient()
        .subscribe(
          SubscriptionOptions<List<(BlueAllianceMatchData, List<String>)>>(
            document: gql(subscription),
            parserFn: (final Map<String, dynamic> data) {
              final List<dynamic> scheduleMatches =
                  data["schedule_matches"] as List<dynamic>;

              return scheduleMatches.where((scheduleMatch) {
                final List<dynamic> technicalMatches =
                    scheduleMatch["technical_matches"] as List<dynamic>;
                return technicalMatches.length == 6;
              }).map((final scheduleMatch) {
                final List<dynamic> technicalMatches =
                    scheduleMatch["technical_matches"] as List<dynamic>;

                final int teleAmpBlue0 = technicalMatches[0]["tele_amp"] as int;
                final int teleAmpBlue1 = technicalMatches[1]["tele_amp"] as int;
                final int teleAmpBlue2 = technicalMatches[2]["tele_amp"] as int;
                final int teleAmpBlue =
                    teleAmpBlue0 + teleAmpBlue1 + teleAmpBlue2;
                final int teleAmpRede3 = technicalMatches[3]["tele_amp"] as int;
                final int teleAmpRed4 = technicalMatches[4]["tele_amp"] as int;
                final int teleAmpRed5 = technicalMatches[5]["tele_amp"] as int;
                final int teleAmpRed = teleAmpRede3 + teleAmpRed4 + teleAmpRed5;
                final int autoSpeakerBlue0 =
                    technicalMatches[0]["auto_speaker"] as int;
                final int autoSpeakerBlue1 =
                    technicalMatches[1]["auto_speaker"] as int;
                final int autoSpeakerBlue2 =
                    technicalMatches[2]["auto_speaker"] as int;
                final int autoSpeakerBlue =
                    autoSpeakerBlue0 + autoSpeakerBlue1 + autoSpeakerBlue2;
                final int autoSpeakerRed3 =
                    technicalMatches[3]["auto_speaker"] as int;
                final int autoSpeakerRed4 =
                    technicalMatches[4]["auto_speaker"] as int;
                final int autoSpeakerRed5 =
                    technicalMatches[5]["auto_speaker"] as int;
                final int autoSpeakerRed =
                    autoSpeakerRed3 + autoSpeakerRed4 + autoSpeakerRed5;
                final int teleSpeakerblue0 =
                    technicalMatches[0]["tele_speaker"] as int;
                final int teleSpeakerBlue1 =
                    technicalMatches[1]["tele_speaker"] as int;
                final int teleSpeakerBlue2 =
                    technicalMatches[2]["tele_speaker"] as int;
                final int teleSpeakerBlue =
                    teleSpeakerblue0 + teleSpeakerBlue1 + teleSpeakerBlue2;
                final int teleSpeakerRed3 =
                    technicalMatches[3]["tele_speaker"] as int;
                final int teleSpeakerRed4 =
                    technicalMatches[4]["tele_speaker"] as int;
                final int teleSpeakerRed5 =
                    technicalMatches[5]["tele_speaker"] as int;
                final int teleSpeakerRed =
                    teleSpeakerRed3 + teleSpeakerRed4 + teleSpeakerRed5;
                final List<String> scouterName = technicalMatches
                    .map(
                      (final dynamic match) => match["scouter_name"] as String,
                    )
                    .toList();
                final int matchNumber = scheduleMatch["match_number"] as int;
                return (
                  BlueAllianceMatchData(
                    blueScore:
                        teleAmpBlue + (teleSpeakerBlue + autoSpeakerBlue) * 2,
                    redScore:
                        (teleSpeakerRed + autoSpeakerRed) * 2 + teleAmpRed,
                    blueNotesAutoSpeaker: autoSpeakerBlue,
                    redNotesAutoSpeaker: autoSpeakerRed,
                    blueNotesTeleAmp: teleAmpBlue,
                    redNotesTeleAmp: teleAmpRed,
                    totalBlueNotesTeleSpeaker: teleSpeakerBlue,
                    totalRedNotesTeleSpeaker: teleSpeakerRed,
                    matchNumber: matchNumber,
                  ),
                  scouterName,
                );
              }).toList();
            },
          ),
        )
        .map(
          (
            final QueryResult<List<(BlueAllianceMatchData, List<String>)>>
                event,
          ) =>
              event.mapQueryResult(),
        );

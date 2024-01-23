import "dart:collection";

import "package:graphql/client.dart";
import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/models/match_model.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/compare/models/compare_classes.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

const String query = """

query FetchCompare(\$ids: [Int!]) {
  team(where: {id: {_in: \$ids}}) {
    technical_matches_aggregate(where: {ignored: {_eq: false}}) {
      aggregate {
        avg {
          auto_amp
          auto_amp_missed
          auto_speaker
          auto_speaker_missed
          tele_amp
          tele_amp_missed
          tele_speaker
          tele_speaker_missed
          trap_amount
        }
      }
    }
    specific_matches{
      defense_amount_id
      defense{
        title
      }
    }
    technical_matches(where: {ignored: {_eq: false}},order_by:[ {schedule_match: {match_type: {order: asc}}},{ schedule_match:{match_number:asc}},{is_rematch: asc}]) {
      
      schedule_match{
        match_number
      }
      		auto_amp
          auto_amp_missed
          auto_speaker
          auto_speaker_missed
          tele_amp
          tele_amp_missed
          tele_speaker
          tele_speaker_missed
          trap_amount
    }
    name
    number
    id
    colors_index
  }
}
""";

Future<SplayTreeSet<CompareTeam>> fetchData(
  final List<int> ids,
) async {
  final GraphQLClient client = getClient();

  final QueryResult<SplayTreeSet<CompareTeam>> result = await client.query(
    QueryOptions<SplayTreeSet<CompareTeam>>(
      parserFn: (final Map<String, dynamic> teams) =>
          SplayTreeSet<CompareTeam>.from(
        (teams["team"] as List<dynamic>)
            .map<CompareTeam>((final dynamic teamsTable) {
          final LightTeam team = LightTeam.fromJson(teamsTable);
          final List<dynamic> technicalMatches =
              teamsTable["technical_matches"] as List<dynamic>;
          final List<dynamic> specificMatches =
              teamsTable["specific_matches"] as List<dynamic>;
          final List<int> autoGamepieces = technicalMatches
              .map(
                (final dynamic technicalMatch) => (getPieces(
                      parseByMode(MatchMode.auto, technicalMatch),
                    ).toInt() -
                    ((technicalMatch["auto_amp_missed"] as int) +
                        (technicalMatch["auto_speaker_missed"] as int))),
              )
              .toList();
          final List<int> teleGamepieces = technicalMatches
              .map(
                (final dynamic technicalMatch) => (getPieces(
                      parseByMode(MatchMode.tele, technicalMatch),
                    ).toInt() -
                    ((technicalMatch["tele_amp_missed"] as int) +
                        (technicalMatch["tele_speaker_missed"] as int))),
              )
              .toList();
          final List<int> totalMissed = technicalMatches
              .map(
                (final dynamic technicalMatch) =>
                    ((technicalMatch["auto_amp_missed"] as int) +
                        (technicalMatch["auto_speaker_missed"] as int)) +
                    ((technicalMatch["tele_amp_missed"] as int) +
                        (technicalMatch["tele_speaker_missed"] as int)),
              )
              .toList();
          final List<int> gamepieces = technicalMatches
              .map(
                (final dynamic technicalMatch) => getPieces(
                  parseMatch(technicalMatch),
                ).toInt(),
              )
              .toList();
          final List<int> gamepiecePoints = technicalMatches
              .map(
                (final dynamic technicalMatch) => (getPoints(
                  parseMatch(technicalMatch),
                ).toInt()),
              )
              .toList();

          final List<int> totalAmps = technicalMatches
              .map(
                (final dynamic technicalMatch) =>
                    (technicalMatch["auto_amp"] as int) +
                    (technicalMatch["tele_amp"] as int),
              )
              .toList();
          final List<int> totalSpeakers = technicalMatches
              .map(
                (final dynamic technicalMatch) =>
                    (technicalMatch["auto_speaker"] as int) +
                    (technicalMatch["tele_speaker"] as int),
              )
              .toList();
          final dynamic avg =
              teamsTable["technical_matches_aggregate"]["aggregate"]["avg"];
          final bool avgNullValidator = avg["auto_amp"] == null;
          final double avgTeleGamepiecesPoints = avgNullValidator
              ? double.nan
              : getPieces(parseByMode(MatchMode.tele, avg));
          final double avgAutoGamepiecePoints = avgNullValidator
              ? double.nan
              : getPoints(parseByMode(MatchMode.auto, avg));

          final List<RobotMatchStatus> matchStatuses = technicalMatches
              .map(
                (final dynamic e) => robotMatchStatusTitleToEnum(
                  e["robot_match_status"]["title"] as String,
                ),
              )
              .toList();
          final List<DefenseAmount> defenceAmounts = <DefenseAmount>[
            for (int i = 0; i < technicalMatches.length; i++)
              if (i >= specificMatches.length)
                DefenseAmount.noDefense
              else
                defenseAmountTitleToEnum(
                  (specificMatches[i] as dynamic)["defense"]["title"] as String,
                ),
          ];

          final CompareLineChartData totalSpeakerLineChart =
              CompareLineChartData(
            points: totalSpeakers,
            matchStatuses: matchStatuses,
            defenseAmounts: defenceAmounts,
          );
          final CompareLineChartData totalAmpsLineChart = CompareLineChartData(
            points: totalAmps,
            matchStatuses: matchStatuses,
            defenseAmounts: defenceAmounts,
          );
          final CompareLineChartData gamepiecesLine = CompareLineChartData(
            points: gamepieces,
            matchStatuses: matchStatuses,
            defenseAmounts: defenceAmounts,
          );
          final CompareLineChartData autoGamepiecesLineChart =
              CompareLineChartData(
            points: autoGamepieces,
            matchStatuses: matchStatuses,
            defenseAmounts: defenceAmounts,
          );
          final CompareLineChartData teleGamepiecesLineChart =
              CompareLineChartData(
            points: teleGamepieces,
            matchStatuses: matchStatuses,
            defenseAmounts: defenceAmounts,
          );
          final CompareLineChartData pointLineChart = CompareLineChartData(
            points: gamepiecePoints,
            matchStatuses: matchStatuses,
            defenseAmounts: defenceAmounts,
          );
          final CompareLineChartData totalMissedLineChart =
              CompareLineChartData(
            points: totalMissed,
            matchStatuses: matchStatuses,
            defenseAmounts: defenceAmounts,
          );

          return CompareTeam(
            gamepieces: gamepiecesLine,
            gamepiecePoints: pointLineChart,
            team: team,
            totalSpeakers: totalAmpsLineChart,
            totalAmps: totalSpeakerLineChart,
            teleGamepieces: teleGamepiecesLineChart,
            autoGamepieces: autoGamepiecesLineChart,
            avgAutoGamepiecePoints: avgAutoGamepiecePoints,
            avgTeleGamepiecesPoints: avgTeleGamepiecesPoints,
            totalDelivered: totalMissedLineChart,
          );
        }),
        (final CompareTeam team1, final CompareTeam team2) =>
            team1.team.id.compareTo(team2.team.id),
      ),
      document: gql(query),
      variables: <String, dynamic>{
        "ids": ids,
      },
    ),
  );
  return result.mapQueryResult();
}

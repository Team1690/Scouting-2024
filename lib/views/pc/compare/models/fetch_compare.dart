import "dart:collection";
import "package:collection/collection.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/models/match_model.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/compare/models/compare_classes.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

const String query = r"""

query FetchCompare($ids: [Int!]) {
  team(where: {id: {_in: $ids}}) {
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
      climb {
        title
      }
      robot_field_status {
        title
      }
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
                (final dynamic technicalMatch) =>
                    (parseByMode<int>(MatchMode.auto, technicalMatch)
                        .values
                        .sum),
              )
              .toList();
          final List<int> teleGamepieces = technicalMatches
              .map(
                (final dynamic technicalMatch) =>
                    (parseByMode<int>(MatchMode.tele, technicalMatch)
                        .values
                        .sum),
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
                (final dynamic technicalMatch) =>
                    parseMatch<int>(technicalMatch).values.sum,
              )
              .toList();
          final List<int> gamepiecePoints = technicalMatches
              .map(
                (final dynamic technicalMatch) =>
                    parseMatch<int>(technicalMatch)
                        .values
                        .mapIndexed(
                          (final int index, final int element) =>
                              parseMatch(technicalMatch)
                                  .keys
                                  .toList()[index]
                                  .points *
                              element,
                        )
                        .toList()
                        .sum,
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
              : parseByMode<double>(MatchMode.tele, avg).values.sum;
          final double avgAutoGamepiecePoints = avgNullValidator
              ? double.nan
              : parseByMode<double>(MatchMode.auto, avg).values.sum;

          final List<RobotMatchStatus> matchStatuses = technicalMatches
              .map(
                (final dynamic e) => robotMatchStatusTitleToEnum(
                  e["robot_field_status"]["title"] as String,
                ),
              )
              .toList();
          final List<DefenseAmount> defenceAmounts = <DefenseAmount>[
            for (int i = 0; i < technicalMatches.length; i++)
              if (i >= specificMatches.length)
                DefenseAmount.noDefense
              else
                defenseAmountTitleToEnum(
                  specificMatches[i]["defense"]["title"] as String,
                ),
          ];
          final List<int> gamesClimbed = technicalMatches
              .map((final dynamic e) =>
                  e["climb"]["title"] as String == "Climbed" ? 1 : 0)
              .toList();

          CompareLineChartData compareLinechart(final List<int> points) =>
              CompareLineChartData(
                points: points,
                matchStatuses: matchStatuses,
                defenseAmounts: defenceAmounts,
              );

          final CompareLineChartData totalSpeakerLineChart =
              compareLinechart(totalSpeakers);
          final CompareLineChartData totalAmpsLineChart =
              compareLinechart(totalAmps);
          final CompareLineChartData gamepiecesLine =
              compareLinechart(gamepieces);
          final CompareLineChartData autoGamepiecesLineChart =
              compareLinechart(autoGamepieces);
          final CompareLineChartData teleGamepiecesLineChart =
              compareLinechart(teleGamepieces);
          final CompareLineChartData pointLineChart =
              compareLinechart(gamepiecePoints);
          final CompareLineChartData totalMissedLineChart =
              compareLinechart(totalMissed);
          final CompareLineChartData climbed = compareLinechart(gamesClimbed);
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
            climbed: climbed,
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

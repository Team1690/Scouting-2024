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
                    (parseByMode(MatchMode.auto, technicalMatch).values.reduce(
                          (final int value, final int element) =>
                              value + element,
                        )),
              )
              .toList();
          final List<int> teleGamepieces = technicalMatches
              .map(
                (final dynamic technicalMatch) =>
                    (parseByMode(MatchMode.tele, technicalMatch).values.reduce(
                          (final int value, final int element) =>
                              value + element,
                        )),
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
                    parseMatch(technicalMatch).values.reduce(
                          (final int value, final int element) =>
                              value + element,
                        ),
              )
              .toList();
          final List<int> gamepiecePoints = technicalMatches
              .map(
                (final dynamic technicalMatch) => parseMatch(technicalMatch)
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
                    .reduce(
                      (final int value, final int element) => value + element,
                    ),
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
          final bool avgNullValidator = avg["auto_amp"] == 0;
          print(1);
          /*final double avgTeleGamepiecesPoints = avgNullValidator
              ? double.nan
              : parseByMode(MatchMode.tele, avg).values.fold(
                    0,
                    (final double previousValue, final int element) =>
                        previousValue + element,
                  );
          final double avgAutoGamepiecePoints = avgNullValidator
              ? double.nan
              : parseByMode(MatchMode.auto, avg).values.fold(
                    0,
                    (final double previousValue, final int element) =>
                        previousValue + element,
                  );*/
          print(2);

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
          //TODO:
          return CompareTeam(
            gamepieces: gamepiecesLine,
            gamepiecePoints: pointLineChart,
            team: team,
            totalSpeakers: totalAmpsLineChart,
            totalAmps: totalSpeakerLineChart,
            teleGamepieces: teleGamepiecesLineChart,
            autoGamepieces: autoGamepiecesLineChart,
            avgAutoGamepiecePoints: 0,
            avgTeleGamepiecesPoints: 0,
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
  print(3);
  return result.mapQueryResult();
}

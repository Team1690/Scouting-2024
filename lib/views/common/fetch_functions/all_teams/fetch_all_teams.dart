import "package:graphql/client.dart";
import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import 'package:scouting_frontend/views/common/fetch_functions/all_teams/all_team_data.dart';
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

const String subscription = r"""
subscription FetchAllTeams {
  team {
    id
    name
    number
    first_picklist_index
    second_picklist_index
    colors_index
    technical_matches_aggregate {
      aggregate {
        avg {
          auto_amp
          auto_amp_missed
          auto_speaker
          auto_speaker_missed
          trap_amount
          tele_speaker_missed
          tele_speaker
          tele_amp_missed
          tele_amp
        }
      }
      nodes {
        climb {
          title
          order
          points
        }
        robot_field_status {
          title
        }
      }
    }
  }
}


""";

Stream<List<AllTeamData>> fetchAllTeams() => getClient()
    .subscribe(
      SubscriptionOptions<List<AllTeamData>>(
        document: gql(subscription),
        parserFn: (final Map<String, dynamic> data) {
          final List<dynamic> teams = data["team"] as List<dynamic>;
          return teams.map<AllTeamData>((final dynamic team) {
            final List<RobotMatchStatus> robotMatchStatuses =
                (team["technical_matches_aggregate"]["nodes"] as List<dynamic>)
                    .map(
                      (final dynamic node) => robotMatchStatusTitleToEnum(
                        node["robot_field_status"]["title"] as String,
                      ),
                    )
                    .toList();
            final dynamic avg =
                team["technical_matches_aggregate"]["aggregate"]["avg"];
            final bool nullValidator = avg["auto_amp"] == null;
            final double autoGamepieceMissed = nullValidator
                ? double.nan
                : (avg["auto_amp_missed"] as double) +
                    (avg["auto_speaker_missed"] as double);
            final double teleGamepieceMissed = nullValidator
                ? double.nan
                : (avg["tele_amp_missed"] as double) +
                    (avg["tele_speaker_missed"] as double);
            final double gamepiecePointsAvg = avg["auto_cones_top"] == null
                ? double.nan
                : getPoints(parseMatch(avg));
            final double autoGamepieceAvg = avg["auto_cones_top"] == null
                ? double.nan
                : getPieces(
                    parseByMode(
                      MatchMode.auto,
                      avg,
                    ),
                  );
            final double teleGamepieceAvg = avg["auto_cones_top"] == null
                ? double.nan
                : getPieces(
                    parseByMode(
                      MatchMode.tele,
                      avg,
                    ),
                  );
            final double gamepieceSum = avg["auto_cones_top"] == null
                ? double.nan
                : getPieces(parseMatch(avg));
            final double autoBalancePointAvg =
                autoBalancePoints.averageOrNull ?? double.nan;
            final double endgameBalancePointAvg =
                endgameBalancePoints.averageOrNull ?? double.nan;
            endgameBalancePoints.averageOrNull ?? double.nan;
            return _Team(
              amountOfMatches: (team["technical_matches_aggregate"]["nodes"]
                      as List<dynamic>)
                  .length,
              matchesBalanced: (team["technical_matches_aggregate"]["nodes"]
                      as List<dynamic>)
                  .map(
                    (final dynamic node) =>
                        node["auto_balance"]["title"] as String,
                  )
                  .where(
                    (final String title) =>
                        title != "No attempt" && title != "Failed",
                  )
                  .length,
              autoBalancePercentage: autoBalancePercentage,
              brokenMatches: robotMatchStatuses
                  .where(
                    (final RobotMatchStatus robotMatchStatus) =>
                        robotMatchStatus != RobotMatchStatus.worked,
                  )
                  .length,
              autoGamepieceAvg: autoGamepieceAvg - autoGamepieceDelivered,
              teleGamepieceAvg: teleGamepieceAvg,
              gamepieceAvg: gamepieceSum -
                  autoGamepieceDelivered -
                  teleGamepieceDelivered,
              deliveredAvg: autoGamepieceDelivered + teleGamepieceDelivered,
              gamepiecePointAvg: gamepiecePointsAvg,
              team: LightTeam.fromJson(team),
              autoBalancePointsAvg: autoBalancePointAvg,
              endgameBalancePointsAvg: endgameBalancePointAvg,
            );
          }).toList();
        },
      ),
    )
    .map(
      (final QueryResult<List<_Team>> event) => event.mapQueryResult(),
    );

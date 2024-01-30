import "package:graphql/client.dart";
import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/fetch_functions/all_teams/all_team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/parse_match_functions.dart";
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
            final double gamepiecePointsAvg = nullValidator
                ? double.nan
                : getPoints<double>(parseMatch<double>(avg));
            final double autoGamepieceAvg = nullValidator
                ? double.nan
                : getPieces<double>(
                    parseByMode<double>(
                      MatchMode.auto,
                      avg,
                    ),
                  );
            final double teleGamepieceAvg = nullValidator
                ? double.nan
                : getPieces<double>(
                    parseByMode<double>(
                      MatchMode.tele,
                      avg,
                    ),
                  );
            final double gamepieceSum = nullValidator
                ? double.nan
                : getPieces<double>(parseMatch<double>(avg));
            final double avgTraps =
                nullValidator ? double.nan : avg["trap_amount"] as double;
            final int firstPicklistIndex = team["first_picklist_index"] as int;
            final int secondPicklistIndex =
                team["second_picklist_index"] as int;
            return AllTeamData(
              amountOfMatches: (team["technical_matches_aggregate"]["nodes"]
                      as List<dynamic>)
                  .length,
              matchesClimbed: (team["technical_matches_aggregate"]["nodes"]
                      as List<dynamic>)
                  .map(
                    (final dynamic node) => node["climb"]["title"] as String,
                  )
                  .where(
                    (final String title) =>
                        title != "No attempt" && title != "Failed",
                  )
                  .length,
              brokenMatches: robotMatchStatuses
                  .where(
                    (final RobotMatchStatus robotMatchStatus) =>
                        robotMatchStatus != RobotMatchStatus.worked,
                  )
                  .length,
              autoGamepieceAvg: autoGamepieceAvg,
              teleGamepieceAvg: teleGamepieceAvg,
              gamepieceAvg: gamepieceSum,
              missedAvg: autoGamepieceMissed + teleGamepieceMissed,
              gamepiecePointAvg: gamepiecePointsAvg,
              team: LightTeam.fromJson(team),
              firstPicklistIndex: firstPicklistIndex,
              secondPicklistIndex: secondPicklistIndex,
              trapAverage: avgTraps,
            );
          }).toList();
        },
      ),
    )
    .map(
      (final QueryResult<List<AllTeamData>> event) => event.mapQueryResult(),
    );

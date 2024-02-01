import "package:graphql/client.dart";
import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/fetch_functions/all_teams/all_team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/climb_enum.dart";
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
    third_picklist_index
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
    taken
    faults {
      message
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
            final List<RobotFieldStatus> robotFieldStatuses =
                (team["technical_matches_aggregate"]["nodes"] as List<dynamic>)
                    .map(
                      (final dynamic node) => robotFieldStatusTitleToEnum(
                        node["robot_field_status"]["title"] as String,
                      ),
                    )
                    .toList();
            final dynamic avg =
                team["technical_matches_aggregate"]["aggregate"]["avg"];
            final bool avgNullValidator = avg["auto_amp"] == null;
            final double autoGamepieceMissed = avgNullValidator
                ? double.nan
                : (avg["auto_amp_missed"] as double) +
                    (avg["auto_speaker_missed"] as double);
            final double teleGamepieceMissed = avgNullValidator
                ? double.nan
                : (avg["tele_amp_missed"] as double) +
                    (avg["tele_speaker_missed"] as double);
            final double gamepiecePointsAvg = avgNullValidator
                ? double.nan
                : getPoints<double>(parseMatch<double>(avg));
            final double autoGamepieceAvg = avgNullValidator
                ? double.nan
                : getPieces<double>(
                    parseByMode<double>(
                      MatchMode.auto,
                      avg,
                    ),
                  );
            final double teleGamepieceAvg = avgNullValidator
                ? double.nan
                : getPieces<double>(
                    parseByMode<double>(
                      MatchMode.tele,
                      avg,
                    ),
                  );
            final double gamepieceSum = avgNullValidator
                ? double.nan
                : getPieces<double>(parseMatch<double>(avg));
            final double avgTraps =
                avgNullValidator ? double.nan : avg["trap_amount"] as double;
            final int firstPicklistIndex = team["first_picklist_index"] as int;
            final int secondPicklistIndex =
                team["second_picklist_index"] as int;
            final bool taken = team["taken"] as bool;
            final List<String> faultMessages = (team["faults"] as List<dynamic>)
                .map((final dynamic e) => e["message"] as String)
                .toList();
            final int amountOfMatches =
                (team["technical_matches_aggregate"]["nodes"] as List<dynamic>)
                    .length;
            final double workedPercentage = 100 *
                (robotFieldStatuses
                        .where(
                          (final RobotFieldStatus robotMatchStatus) =>
                              robotMatchStatus == RobotFieldStatus.worked,
                        )
                        .length /
                    amountOfMatches);
            final double teleAmpAvg =
                avgNullValidator ? double.nan : avg["tele_amp"] as double;
            final double teleSpeakerAvg =
                avgNullValidator ? double.nan : avg["tele_speaker"] as double;

            final int thirdPicklistIndex = team["third_picklist_index"] as int;
            final List<Climb> climbed =
                (team["technical_matches_aggregate"]["nodes"] as List<dynamic>)
                    .map(
                      (final dynamic e) =>
                          climbTitleToEnum(e["climb"]["title"] as String),
                    )
                    .toList();
            final double climbedPercentage = 100 *
                climbed
                    .where(
                      (final Climb element) =>
                          element == Climb.climbed ||
                          element == Climb.buddyClimbed,
                    )
                    .length /
                climbed.length;

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
              brokenMatches: robotFieldStatuses
                  .where(
                    (final RobotFieldStatus robotMatchStatus) =>
                        robotMatchStatus != RobotFieldStatus.worked,
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
              thirdPickListIndex: thirdPicklistIndex,
              taken: taken,
              faultMessages: faultMessages,
              workedPercentage: workedPercentage,
              teleAmpAvg: teleAmpAvg,
              teleSpeakerAvg: teleSpeakerAvg,
              climbedPercentage: climbedPercentage,
            );
          }).toList();
        },
      ),
    )
    .map(
      (final QueryResult<List<AllTeamData>> event) => event.mapQueryResult(),
    );

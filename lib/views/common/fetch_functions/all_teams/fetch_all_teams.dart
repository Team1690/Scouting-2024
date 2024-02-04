import "package:collection/collection.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/fetch_functions/aggregate_data/aggregate_technical_data.dart";
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
          traps_missed
          tele_speaker_missed
          tele_speaker
          tele_amp_missed
          tele_amp
        }
        max {
          auto_amp
          auto_amp_missed
          auto_speaker
          auto_speaker_missed
          trap_amount
          traps_missed
          tele_speaker_missed
          tele_speaker
          tele_amp_missed
          tele_amp
        }
        min {
          auto_amp
          auto_amp_missed
          auto_speaker
          auto_speaker_missed
          trap_amount
          traps_missed
          tele_speaker_missed
          tele_speaker
          tele_amp_missed
          tele_amp
        }
        stddev {
          auto_amp
          auto_amp_missed
          auto_speaker
          auto_speaker_missed
          tele_amp_missed
          tele_speaker
          tele_speaker_missed
          tele_amp
          trap_amount
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
    technical_matches{
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
    taken
    faults {
      message
    }
  }
}





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
                    
            final dynamic aggregateTable =
                team["technical_matches_aggregate"]["aggregate"];
            final bool aggregateNullValidator =
                (aggregateTable["avg"]["auto_amp"] as double?) == null;

            final dynamic stddev =
                team["technical_matches_aggregate"]["aggregate"]["stddev"];
            final double autoGamepieceMissed = aggregateNullValidator
                ? double.nan
                : (avg["auto_amp_missed"] as double) +
                    (avg["auto_speaker_missed"] as double);
            final double teleGamepieceMissed = aggregateNullValidator
                ? double.nan
                : (avg["tele_amp_missed"] as double) +
                    (avg["tele_speaker_missed"] as double);

            final List<dynamic> matches =
                team["technical_matches"] as List<dynamic>;

            final double gamepiecesStddev = stddev["auto_cones_top"] == null
                ? 0
                : getPieces(parseMatch(stddev));

            final double gamepiecePointsAvg = aggregateNullValidator
                ? double.nan
                : getPoints<double>(parseMatch<double>(avg));


            final double gamepiecePointsAvg = aggregateNullValidator
                ? double.nan
                : getPoints<double>(parseMatch<double>(aggregateTable["avg"]));
                
            final double autoGamepieceAvg = aggregateNullValidator
                : getPieces<double>(
                    parseByMode<double>(
                      MatchMode.auto,
                      aggregateTable["avg"],
                    ),
                  );

            final double teleGamepieceAvg = aggregateNullValidator
                : getPieces<double>(
                    parseByMode<double>(
                      MatchMode.tele,
                      aggregateTable["avg"],
                    ),
                  );

            final double gamepieceSum = aggregateNullValidator
                ? double.nan
                : getPieces<double>(parseMatch<double>(avg));

            final Iterable<double> matchesGamepiecePoints = matches
                .map((final dynamic match) => getPoints(parseMatch(match)));

            final double yStddevGamepiecePoints =
                matchesGamepiecePoints.isNotEmpty
                    ? matchesGamepiecePoints
                        .map(
                          (final double matchPoints) =>
                              (matchPoints - gamepiecePointsAvg).abs(),
                        )
                        .average
                    : 0;

            final double avgTraps =
                aggregateNullValidator ? double.nan : avg["trap_amount"] as double;
                ? double.nan
                : getPieces<double>(parseMatch<double>(aggregateTable["avg"]));
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

            final int thirdPicklistIndex = team["third_picklist_index"] as int;
            final List<({Climb climb, RobotFieldStatus robotFieldStatus})>
                climbed =
                (team["technical_matches_aggregate"]["nodes"] as List<dynamic>)
                    .map(
                      (final dynamic e) => (
                        climb: climbTitleToEnum(e["climb"]["title"] as String),
                        robotFieldStatus: robotFieldStatusTitleToEnum(
                          e["robot_field_status"]["title"] as String,
                        )
                      ),
                    )
                    .toList();
            final double climbedPercentage = 100 *
                climbed
                    .where(
                      (
                        final ({
                          Climb climb,
                          RobotFieldStatus robotFieldStatus
                        }) element,
                      ) =>
                          element.climb == Climb.climbed ||
                          element.climb == Climb.buddyClimbed,
                    )
                    .length /
                climbed
                    .where(
                      (
                        final ({
                          Climb climb,
                          RobotFieldStatus robotFieldStatus
                        }) element,
                      ) =>
                          element.climb != Climb.noAttempt &&
                          element.robotFieldStatus == RobotFieldStatus.worked,
                    )
                    .length;

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
              gamepiecesStddev: gamepiecesStddev,
              yStddevGamepiecePoints: yStddevGamepiecePoints,
              autoGamepieceAvg: autoGamepieceAvg,
              teleGamepieceAvg: teleGamepieceAvg,
              gamepieceAvg: gamepieceSum,
              gamepiecePointAvg: gamepiecePointsAvg,
              team: LightTeam.fromJson(team),
              firstPicklistIndex: firstPicklistIndex,
              secondPicklistIndex: secondPicklistIndex,
              thirdPickListIndex: thirdPicklistIndex,
              taken: taken,
              faultMessages: faultMessages,
              workedPercentage: workedPercentage,
              climbedPercentage: climbedPercentage,
              aggregateData: AggregateData.parse(aggregateTable),
            );
          }).toList();
        },
      ),
    )
    .map(
      (final QueryResult<List<AllTeamData>> event) => event.mapQueryResult(),
    );

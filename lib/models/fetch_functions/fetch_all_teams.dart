import "package:graphql/client.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/models/team_data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/team_data/all_team_data.dart";
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
        count
        stddev {
          auto_amp
          auto_amp_missed
          auto_speaker
          auto_speaker_missed
          tele_amp
          tele_amp_missed
          tele_speaker
          tele_speaker_missed
          trap_amount
          traps_missed
        }
        sum {
          traps_missed
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
        variance {
          auto_amp
          auto_amp_missed
          auto_speaker
          auto_speaker_missed
          tele_amp
          tele_amp_missed
          tele_speaker
          tele_speaker_missed
          trap_amount
          traps_missed
        }
      }
      nodes {
        climb {
          title
        }
        robot_field_status {
          title
        }
        auto_amp
        auto_amp_missed
        auto_speaker
        auto_speaker_missed
        harmony_with
        tele_amp
        tele_amp_missed
        tele_speaker
        tele_speaker_missed
        trap_amount
        traps_missed
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
            final List<dynamic> technicalMatchesTable =
                team["technical_matches_aggregate"]["nodes"] as List<dynamic>;
            final dynamic aggregateTable =
                team["technical_matches_aggregate"]["aggregate"];
            final List<dynamic> faultTable = (team["faults"] as List<dynamic>);
            // final double climbedPercentage = 100 *
            //     climbed
            //         .where(
            //           (
            //             final ({
            //               Climb climb,
            //               RobotFieldStatus robotFieldStatus
            //             }) element,
            //           ) =>
            //               element.climb == Climb.climbed ||
            //               element.climb == Climb.buddyClimbed,
            //         )
            //         .length /
            //     climbed
            //         .where(
            //           (
            //             final ({
            //               Climb climb,
            //               RobotFieldStatus robotFieldStatus
            //             }) element,
            //           ) =>
            //               element.climb != Climb.noAttempt &&
            //               element.robotFieldStatus == RobotFieldStatus.worked,
            //         )
            //         .length;

            return AllTeamData(
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
              team: LightTeam.fromJson(team),
              firstPicklistIndex: team["first_picklist_index"] as int,
              secondPicklistIndex: team["second_picklist_index"] as int,
              thirdPickListIndex: team["third_picklist_index"] as int,
              taken: team["taken"] as bool,
              faultMessages: faultMessages,
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

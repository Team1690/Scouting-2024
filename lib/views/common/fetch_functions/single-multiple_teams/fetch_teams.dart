import "dart:collection";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/fetch_functions/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_match_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_summary_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/pit_data/pit_data.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view.dart";

const String query = r"""
query FetchTeams($ids: [Int!]) @cached {
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
          traps_missed
        }
        max {
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
        min {
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
    }
    specific_matches {
      defense_amount_id
      defense {
        title
      }
      defense_rating
      driving_rating
      general_rating
      intake_rating
      is_rematch
      speaker_rating
      url
      climb_rating
      amp_rating
      schedule_match {
        id
        match_number
        match_type_id
      }
      scouter_name
    }
    technical_matches(where: {ignored: {_eq: false}}, order_by: [{schedule_match: {match_type: {order: asc}}}, {schedule_match: {match_number: asc}}, {is_rematch: asc}]) {
      schedule_match {
        match_number
        id
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
        points
      }
      robot_field_status {
        title
      }
      harmony_with
      traps_missed
    }
    name
    number
    id
    colors_index
    first_picklist_index
    second_picklist_index
    third_picklist_index
    faults {
      message
      fault_status {
        title
      }
      match_number
      match_type {
        title
      }
      id
      team {
        name
        number
        id
        colors_index
      }
    }
    pit {
      drive_motor_amount
      wheel_type {
        title
      }
      drivemotor {
        title
      }
      drivetrain {
        title
      }
      gearbox_purchased
      harmony
      has_buddy_climb
      has_shifter
      height
      notes
      trap
      weight
      url
      team {
        faults {
          message
        }
        name
        number
        id
        colors_index
      }
    }
    specific_summary {
      amp_text
      climb_text
      driving_text
      general_text
      intake_text
      speaker_text
    }
  }
}


""";

Future<SplayTreeSet<TeamData>> fetchMultipleTeamData(
  final List<int> ids,
) async {
  final GraphQLClient client = getClient();

  final QueryResult<SplayTreeSet<TeamData>> result = await client.query(
    QueryOptions<SplayTreeSet<TeamData>>(
      parserFn: (final Map<String, dynamic> teams) =>
          SplayTreeSet<TeamData>.from(
        (teams["team"] as List<dynamic>)
            .map<TeamData>((final dynamic teamTable) {
          final LightTeam team = LightTeam.fromJson(teamTable);
          final int firstPicklistIndex =
              teamTable["first_picklist_index"] as int;
          final int secondPicklistIndex =
              teamTable["second_picklist_index"] as int;
          final int thirdPicklistIndex =
              teamTable["third_picklist_index"] as int;
          final List<dynamic> technicalMatchesTable =
              teamTable["technical_matches"] as List<dynamic>;
          final List<dynamic> specificMatchesTables =
              teamTable["specific_matches"] as List<dynamic>;
          final dynamic aggregateTable =
              teamTable["technical_matches_aggregate"]["aggregate"];
          final dynamic pitTable = teamTable["pit"];
          final List<dynamic> faultTable = teamTable["faults"] as List<dynamic>;
          final dynamic specificSummaryTable = teamTable["specific_summary"];

          return TeamData(
            aggregateData: AggregateData.parse(aggregateTable),
            technicalMatches:
                technicalMatchesTable.map(TechnicalMatchData.parse).toList(),
            pitData: PitData.parse(pitTable),
            faultEntrys: faultTable.map(FaultEntry.parse).toList(),
            specificMatches:
                specificMatchesTables.map(SpecificMatchData.parse).toList(),
            summaryData: SpecificSummaryData.parse(specificSummaryTable),
            lightTeam: team,
            firstPicklistIndex: firstPicklistIndex,
            secondPicklistIndex: secondPicklistIndex,
            thirdPicklistIndex: thirdPicklistIndex,
          );
        }),
        (final TeamData team1, final TeamData team2) =>
            team1.lightTeam.number.compareTo(team2.lightTeam.number),
      ),
      document: gql(query),
      variables: <String, dynamic>{
        "ids": ids,
      },
    ),
  );
  return result.mapQueryResult();
}

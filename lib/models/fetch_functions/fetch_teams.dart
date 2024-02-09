import "dart:collection";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/matches_provider.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/models/team_data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_data/specific_match_data.dart";
import "package:scouting_frontend/models/team_data/specific_summary_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "package:scouting_frontend/models/team_data/pit_data/pit_data.dart";
import "package:scouting_frontend/views/mobile/screens/fault_entry.dart";

const String query = r"""
query FetchTeams($ids: [Int!]) @cached {
  team(where: {id: {_in: $ids}}) {
    specific_matches {
      schedule_match {
        id
        match_type {
          title
        }
        match_number
      }
      is_rematch
      defense_amount_id
      defense {
        title
      }
      defense_rating
      driving_rating
      general_rating
      intake_rating
      speaker_rating
      url
      climb_rating
      amp_rating
      scouter_name
    }
    technical_matches(where: {ignored: {_eq: false}}, order_by: [{schedule_match: {match_type: {order: asc}}}, {schedule_match: {match_number: asc}}, {is_rematch: asc}]) {
      schedule_match {
        id
        match_type {
          title
        }
        match_number
      }
      is_rematch
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
      climb {
        title
        points
      }
      robot_field_status {
        title
      }
      harmony_with
      scouter_name
      starting_position {
        title
      }
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
      other_wheel_type
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
      other_wheel_type
    }
    specific_summary {
      amp_text
      climb_text
      driving_text
      general_text
      intake_text
      speaker_text
      defense_text
    }
  }
}



""";

Future<SplayTreeSet<TeamData>> fetchMultipleTeamData(
  final List<int> ids,
  final BuildContext context,
) async {
  final GraphQLClient client = getClient();

  final QueryResult<SplayTreeSet<TeamData>> result = await client.query(
    QueryOptions<SplayTreeSet<TeamData>>(
      parserFn: (final Map<String, dynamic> teams) =>
          SplayTreeSet<TeamData>.from(
        (teams["team"] as List<dynamic>)
            .map<TeamData>((final dynamic teamTable) {
          final LightTeam team = LightTeam.fromJson(teamTable);
          final List<ScheduleMatch> matches = MatchesProvider.of(context)
              .matches
              .where(
                (final ScheduleMatch element) =>
                    element.blueAlliance.contains(team) ||
                    element.redAlliance.contains(team),
              )
              .toList();

          final int firstPicklistIndex =
              teamTable["first_picklist_index"] as int;
          final int secondPicklistIndex =
              teamTable["second_picklist_index"] as int;
          final int thirdPicklistIndex =
              teamTable["third_picklist_index"] as int;

          final List<TechnicalMatchData> technicalMatches =
              (teamTable["technical_matches"] as List<dynamic>)
                  .map(TechnicalMatchData.parse)
                  .toList();

          final List<SpecificMatchData> specificMatches =
              (teamTable["specific_matches"] as List<dynamic>)
                  .map(SpecificMatchData.parse)
                  .toList();
          final dynamic pitTable = teamTable["pit"];
          final List<dynamic> faultTable = teamTable["faults"] as List<dynamic>;
          final dynamic specificSummaryTable = teamTable["specific_summary"];

          return TeamData(
            aggregateData: AggregateData.fromTechnicalData(
              technicalMatches
                  .map((final TechnicalMatchData e) => e.data)
                  .toList(),
            ),
            pitData: PitData.parse(pitTable),
            faultEntrys: faultTable.map(FaultEntry.parse).toList(),
            summaryData: SpecificSummaryData.parse(specificSummaryTable),
            lightTeam: team,
            firstPicklistIndex: firstPicklistIndex,
            secondPicklistIndex: secondPicklistIndex,
            thirdPicklistIndex: thirdPicklistIndex,
            matches: matches
                .map(
                  (final ScheduleMatch match) => MatchData(
                    technicalMatchData: technicalMatches.firstWhereOrNull(
                      (final TechnicalMatchData element) =>
                          match.matchIdentifier == element.matchIdentifier,
                    ),
                    specificMatchData: specificMatches.firstWhereOrNull(
                      (final SpecificMatchData element) =>
                          match.matchIdentifier == element.matchIdentifier,
                    ),
                    scheduleMatch: match,
                  ),
                )
                .toList(),
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

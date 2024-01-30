import "dart:collection";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/fetch_functions/avg_technical_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_match_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view.dart";
import "package:scouting_frontend/views/common/fetch_functions/pit_data/pit_data.dart";

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
        match_number
        match_type_id
      }
      scouter_name
    }
    technical_matches(where: {ignored: {_eq: false}}, order_by: [{schedule_match: {match_type: {order: asc}}}, {schedule_match: {match_number: asc}}, {is_rematch: asc}]) {
      schedule_match {
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
        points
      }
      robot_field_status {
        title
      }
      harmony_with
    }
    name
    number
    id
    colors_index
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
          final List<dynamic> technicalMatchesTable =
              teamTable["technical_matches"] as List<dynamic>;
          final List<dynamic> specificMatchesTables =
              teamTable["specific_matches"] as List<dynamic>;
          final Map<String, double> avgTable =
              teamTable["technical_matches_aggregate"]["aggregate"]["avg"]
                  as Map<String, double>;
          final dynamic pitTable = teamTable["pit"];
          return TeamData(
            avgData: AvgData.parse(avgTable),
            technicalMatches:
                technicalMatchesTable.map(TechnicalMatchData.parse).toList(),
            pitData: PitData.parse(pitTable),
            faultEntrys: (teamTable["faults"] as List<dynamic>)
                .map(
                  (final dynamic fault) => FaultEntry(
                    fault["message"] as String,
                    team,
                    fault["id"] as int,
                    fault["fault_status"]["title"] as String,
                    fault["match_number"] as int,
                    fault["match_type"]["order"] as int?,
                  ),
                )
                .toList(),
            specificMatches:
                specificMatchesTables.map(SpecificMatchData.parse).toList(),
            lightTeam: team,
          );
        }),
        (final TeamData team1, final TeamData team2) =>
            team1.lightTeam.id.compareTo(team2.lightTeam.id),
      ),
      document: gql(query),
      variables: <String, dynamic>{
        "ids": ids,
      },
    ),
  );
  return result.mapQueryResult();
}

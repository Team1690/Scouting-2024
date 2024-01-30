import "dart:collection";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/fetch_functions/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";
import "package:scouting_frontend/views/common/fetch_functions/pit_data/pit_data.dart";

const String query = r"""
query FetchTeams($ids: [Int!]) @cached {
  team_by_pk(id: \$id) {
    first_picklist_index
    second_picklist_index
    id
    faults {
      message
    }
    pit {
      trap
      has_buddy_climb
      harmony
      height
      weight
      drive_motor_amount
      drive_wheel_type
      gearbox_purchased
      notes
      has_shifter
      url
      drivetrain {
        title
      }
      drivemotor {
        title
      }
    }
    specific_matches{
      schedule_match_id
      defense
      drivetrain_and_driving
      general_notes
      intake
      placement
      is_rematch
      scouter_name
      defense_amount_id
      schedule_match{
        match_type_id
        match_number
      }
      defense{
        title
      }
    }
    technical_matches_aggregate(where: {ignored: {_eq: false}}) {
      aggregate {
        avg {
        }
      }
    }
    technical_matches(
      where: {ignored: {_eq: false}}
      order_by: [{schedule_match: {match_type: {order: asc}}}, {schedule_match: {match_number: asc}}, {is_rematch: asc}]
    ) {
      schedule_match {
        match_type {
          title
        }
      }
      robot_match_status {
        title
      }
      robot_placement{
        title
      }
      schedule_match_id
      is_rematch
      schedule_match {
        match_number
      }
    }
  }
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
          // final List<dynamic> specificMatchesTable =
          //     teamTable["specific_matches"] as List<dynamic>;
          final Map<String, double> avgTable =
              teamTable["technical_matches_aggregate"]["aggregate"]["avg"]
                  as Map<String, double>;
          final dynamic pitTable = teamTable["pit"];
          return TeamData(
            avgAutoSpeakerMissed: avgTable["auto_speaker_missed"] ?? 0,
            avgTeleSpeakerMissed: avgTable["tele_speaker_missed"] ?? 0,
            avgTeleAmpMissed: avgTable["tele_amp_missed"] ?? 0,
            avgAutoAmpMissed: avgTable["auto_amp_missed"] ?? 0,
            avgTeleSpeaker: avgTable["tele_speaker"] ?? 0,
            avgAutoSpeaker: avgTable["auto_speaker"] ?? 0,
            avgAutoAmp: avgTable["auto_amp"] ?? 0,
            avgTeleAmp: avgTable["tele_amp"] ?? 0,
            avgTrapAmount: avgTable["trap_amount"] ?? 0,
            technicalMatches:
                technicalMatchesTable.map(TechnicalMatch.parse).toList(),
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
            specificMatches: <SpecificMatch>[],
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

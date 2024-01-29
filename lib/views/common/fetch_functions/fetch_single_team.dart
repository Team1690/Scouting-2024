import "dart:collection";
import "package:collection/collection.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/models/match_model.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/fetch_functions/climb_enum.dart";
import "package:scouting_frontend/views/common/fetch_functions/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match.dart";
import "package:scouting_frontend/views/pc/compare/models/compare_classes.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

const String query = r"""

query FetchSingleTeam($ids: [Int!]) @cached {
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
    }
    pit {
      drive_motor_amount
      drive_wheel_type
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
    }
  }
}
""";

Future<SplayTreeSet<TeamData>> fetchData(
  final List<int> ids,
) async {
  final GraphQLClient client = getClient();

  final QueryResult<SplayTreeSet<TeamData>> result = await client.query(
    QueryOptions<SplayTreeSet<TeamData>>(
      parserFn: (final Map<String, dynamic> teams) =>
          SplayTreeSet<TeamData>.from(
        (teams["team"] as List<dynamic>)
            .map<TeamData>((final dynamic teamsTable) {
          final LightTeam team = LightTeam.fromJson(teamsTable);
          final List<dynamic> technicalMatchesTable =
              teamsTable["technical_matches"] as List<dynamic>;
          final List<dynamic> specificMatchesTable =
              teamsTable["specific_matches"] as List<dynamic>;
          final Map<String, double> avgTable =
              teamsTable["technical_matches_aggregate"]["aggregate"]["avg"]
                  as Map<String, double>;
          final DefenseAmount defenseAmount = defenseAmountTitleToEnum(
            specificMatchesTable[0]["defense"]["title"] as String,
          );
          final PitData pitData = PitData(driveTrainType: driveTrainType, driveMotorAmount: driveMotorAmount, driveMotorType: driveMotorType, driveWheelType: driveWheelType, gearboxPurchased: gearboxPurchased, notes: notes, hasShifer: hasShifer, url: url, faultMessages: faultMessages, weight: weight, team: team, height: height, harmony: harmony, trap: trap, hasBuddyClimb: hasBuddyClimb,);
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
            defenseAmount: defenseAmount,
            pitData: pitData,
            faultEntry: ,
            lightTeam: lightTeam,
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

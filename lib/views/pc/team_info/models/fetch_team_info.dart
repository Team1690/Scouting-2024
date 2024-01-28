import "package:flutter/cupertino.dart";
import "package:graphql/client.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

//TODO add season specific vars and tables to the query
const String teamInfoQuery = """
query TeamInfo(\$id: Int!) {
  team_by_pk(id: \$id) {
    first_picklist_index
    second_picklist_index
    id
    faults {
      message
    }
    _2023_pit {
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
    _2023_specifics{
      schedule_match_id
      defense
      drivetrain_and_driving
      general_notes
      intake
      placement
      is_rematch
      scouter_name
      defense_amount_id
      match{
        match_type_id
        match_number
      }
      defense_amount{
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
      order_by: [{match: {match_type: {order: asc}}}, {match: {match_number: asc}}, {is_rematch: asc}]
    ) {
      match {
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
      match {
        match_number
      }
    }
  }
}


""";

Future<Team> fetchTeamInfo(
  final LightTeam teamForQuery,
  final BuildContext context,
) async {
  final GraphQLClient client = getClient();

  final QueryResult<Team> result = await client.query(
    QueryOptions<Team>(
      parserFn: (final Map<String, dynamic> team) {
        //couldn't use map nullable because team["team_by_pk"] is dynamic
        final Map<String, dynamic> teamByPk = team["team_by_pk"] != null
            ? team["team_by_pk"] as Map<String, dynamic>
            : throw Exception("that team doesnt exist");
        final Map<String, dynamic>? pit =
            (teamByPk["_2023_pit"] as Map<String, dynamic>?);

        final List<String> faultMessages = (teamByPk["faults"] as List<dynamic>)
            .map((final dynamic e) => e["message"] as String)
            .toList();
        final PitData? pitData = pit.mapNullable<PitData>(
          ////TODO add season-specific variables
          (final Map<String, dynamic> pitTable) => PitData(
            weight: pitTable["weight"] as int,
            driveMotorAmount: pitTable["drive_motor_amount"] as int,
            driveWheelType: pitTable["drive_wheel_type"] as String,
            gearboxPurchased: pitTable["gearbox_purchased"] as bool?,
            notes: pitTable["notes"] as String,
            hasShifer: pitTable["has_shifter"] as bool?,
            url: pitTable["url"] as String,
            driveTrainType: pitTable["drivetrain"]["title"] as String,
            driveMotorType: pitTable["drivemotor"]["title"] as String,
            faultMessages: faultMessages,
            team: teamForQuery,
          ),
        );
        final List<dynamic> matches =
            (teamByPk["technical_matches"] as List<dynamic>);

        final SpecificData specificData = SpecificData(
          (teamByPk["_2023_specifics"] as List<dynamic>)
              .map(
                (final dynamic specific) => SpecificMatch(
                  drivetrainAndDriving:
                      specific["drivetrain_and_driving"] as String?,
                  intake: specific["intake"] as String?,
                  placement: specific["placement"] as String?,
                  generalNotes: specific["general_notes"] as String?,
                  defense: specific["defense"] as String?,
                  isRematch: specific["is_rematch"] as bool,
                  matchNumber: specific["match"]["match_number"] as int,
                  matchTypeId: specific["match"]["match_type_id"] as int,
                  scouterNames: specific["scouter_name"] as String,
                ),
              )
              .toList(),
        );

        //TODO initialize and add season-specific variables and replace 0s
        final QuickData quickData = QuickData(
          amoutOfMatches: 0,
          firstPicklistIndex: 0,
          secondPicklistIndex: 0,
          avgAutoAmp: 0,
          avgAutoMissedAmp: 0,
          avgAutoMissedSpeaker: 0,
          avgAutoSpeaker: 0,
          avgGamePiecesFullDefense: 0,
          avgGamePiecesHalfDefense: 0,
          avgGamePiecesNoDefense: 0,
          avgGamepiecePoints: 0,
          avgGamepieces: 0,
          avgTeleAmp: 0,
          avgTeleMissedAmp: 0,
          avgTeleMissedSpeaker: 0,
          avgTeleSpeaker: 0,
          avgTrap: 0,
          matchesClimbed: 0,
          matchesHarmonized: 0,
        );
        //TODO create with required auto variables
        AutoByPosData getDataByNodeList(final List<dynamic> matchesInPos) =>
            AutoByPosData(
              amoutOfMatches: matchesInPos.length,
            );
        return Team(
          team: teamForQuery,
          specificData: specificData,
          pitViewData: pitData,
          quickData: quickData,
          autoData: AutoData(
            slot3Data: getDataByNodeList(
              matches
                  .where(
                    (final dynamic match) =>
                        match["robot_placement"] != null &&
                        (match["robot_placement"]["title"] as String) ==
                            "slot 3", //TODO rename
                  )
                  .toList(),
            ),
            slot2Data: getDataByNodeList(
              matches
                  .where(
                    (final dynamic match) =>
                        match["robot_placement"] != null &&
                        (match["robot_placement"]["title"] as String) ==
                            "slot 2", //TODO rename
                  )
                  .toList(),
            ),
            slot1Data: getDataByNodeList(
              matches
                  .where(
                    (final dynamic match) =>
                        match["robot_placement"] != null &&
                        (match["robot_placement"]["title"] as String) ==
                            "slot 1", //TODO rename
                  )
                  .toList(),
            ),
          ),
        );
      },
      document: gql(teamInfoQuery),
      variables: <String, dynamic>{
        "id": teamForQuery.id,
      },
    ),
  );
  return result.mapQueryResult();
}

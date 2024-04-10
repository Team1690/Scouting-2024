import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/data/pit_data/pit_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/models/data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";

const String subscription = """
subscription FetchAllTeams {
  team {
    pit {
      drivetrain {
        id
      }
      drivemotor {
        id
      }
      notes
      url
      team {
        faults {
          message
        }
        id
        number
        colors_index
        name
      }
      weight
      length
      width
      harmony
      trap
      can_pass_under_stage
      can_eject
      shooting_range_id
      climb
    }
    id
    name
    number
    first_picklist_index
    second_picklist_index
    third_picklist_index
    colors_index
    taken
    faults {
      message
    }
    technical_matches {
      id
      scouter_name
      cilmb_id
      harmony_with
      is_rematch
      schedule_match {
        match_type {
          id
        }
        match_number
        id
      }
      climb {
        title
        points
        id
      }
      tele_amp
      tele_amp_missed
      tele_speaker
      tele_speaker_missed
      trap_amount
      traps_missed
      robot_field_status {
        id
      }
    }
  }
}




""";

Stream<List<AllTeamData>> fetchAllTeams(final BuildContext context) =>
    getClient()
        .subscribe(
          SubscriptionOptions<List<AllTeamData>>(
            document: gql(subscription),
            parserFn: (final Map<String, dynamic> data) {
              final List<dynamic> teams = data["team"] as List<dynamic>;
              final IdProvider idProvider = IdProvider.of(context);
              return teams.map<AllTeamData>((final dynamic team) {
                final List<TechnicalMatchData> technicalMatches =
                    (team["technical_matches"] as List<dynamic>)
                        .map(
                          (final dynamic match) => TechnicalMatchData.parse(
                            match,
                            idProvider,
                          ),
                        )
                        .toList();
                final List<dynamic> faultTable =
                    (team["faults"] as List<dynamic>);
                final dynamic pitTable = team["pit"];

                return AllTeamData(
                  team: LightTeam.fromJson(team),
                  firstPicklistIndex: (team["first_picklist_index"] as int),
                  secondPicklistIndex: (team["second_picklist_index"] as int),
                  thirdPickListIndex: (team["third_picklist_index"] as int),
                  taken: team["taken"] as bool,
                  faultMessages: faultTable
                      .map((final dynamic fault) => fault["message"] as String)
                      .toList(),
                  aggregateData: AggregateData.fromTechnicalData(
                    technicalMatches
                        .map((final TechnicalMatchData e) => e.data)
                        .toList(),
                  ),
                  technicalMatches: technicalMatches,
                  pitData: PitData.parse(pitTable, idProvider),
                );
              }).toList();
            },
          ),
        )
        .map(
          (final QueryResult<List<AllTeamData>> event) =>
              event.mapQueryResult(),
        );

import "package:graphql/client.dart";
import "package:scouting_frontend/models/data/pit_data/pit_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/models/data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";

const String subscription = r"""
subscription FetchAllTeams {
  team {
    pit {
      drivetrain {
        title
      }
      drivemotor {
        title
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
      auto_amp
      auto_amp_missed
      auto_speaker
      auto_speaker_missed
      cilmb_id
      harmony_with
      is_rematch
      schedule_match {
        match_type {
          title
        }
        match_number
        id
      }
      climb {
        title
        points
      }
      tele_amp
      tele_amp_missed
      tele_speaker
      tele_speaker_missed
      trap_amount
      traps_missed
      starting_position {
        title
      }
      robot_field_status {
        title
      }
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
            final List<TechnicalMatchData> technicalMatches =
                (team["technical_matches"] as List<dynamic>)
                    .map(TechnicalMatchData.parse)
                    .toList();
            final List<dynamic> faultTable = (team["faults"] as List<dynamic>);
            final dynamic pitTable = team["pit"];

            return AllTeamData(
              team: LightTeam.fromJson(team),
              firstPicklistIndex: team["first_picklist_index"] as int,
              secondPicklistIndex: team["second_picklist_index"] as int,
              thirdPickListIndex: team["third_picklist_index"] as int,
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
              pitData: PitData.parse(pitTable),
            );
          }).toList();
        },
      ),
    )
    .map(
      (final QueryResult<List<AllTeamData>> event) => event.mapQueryResult(),
    );

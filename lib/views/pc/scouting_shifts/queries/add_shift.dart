import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

String addShiftMutation = """
mutation AddShifts(\$scouting_shifts: [scouting_shifts_insert_input!]!) {
  insert_scouting_shifts(objects: \$scouting_shifts) {
    affected_rows
  }
}

""";

void addShift(final ScoutingShift shift) {
  getClient().mutate(
    MutationOptions<void>(
      document: gql(addShiftMutation),
      variables: <String, dynamic>{
        "scouter_shifts": <Map<String, dynamic>>[
          <String, dynamic>{
            "scouter_name": shift.name,
            "schedule_id": shift.scheduleId,
            "team_id": shift.team.id,
          },
        ],
      },
    ),
  );
}

void addShifts(final List<ScoutingShift> shifts) {
  final GraphQLClient client = getClient();
  client.mutate(
    MutationOptions<void>(
      document: gql(addShiftMutation),
      variables: <String, dynamic>{
        "scouting_shifts": <Map<String, Object>>[
          for (final ScoutingShift shift in shifts)
            <String, Object>{
              "scouter_name": shift.name,
              "schedule_id": shift.scheduleId,
              "team_id": shift.team.id,
            },
        ],
      },
    ),
  );
}

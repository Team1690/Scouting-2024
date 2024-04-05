import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

String addShiftMutation = """
mutation AddShift(\$schedule_id: Int!, \$scouter_name: String!, \$team_id: Int!) {
  insert_scouting_shifts(objects: {schedule_id: \$schedule_id, scouter_name: \$scouter_name, team_id: \$team_id}) {
    affected_rows
  }
}

""";

void addShift(final ScoutingShift shift) {
  getClient().mutate(
    MutationOptions<void>(
      document: gql(addShiftMutation),
      variables: <String, dynamic>{
        "scouter_name": shift.name,
        "schedule_id": shift.scheduleId,
        "team_id": shift.team.id,
      },
    ),
  );
}

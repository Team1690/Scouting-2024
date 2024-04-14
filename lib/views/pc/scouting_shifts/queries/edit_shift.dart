import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";

String changeScouterMutation = """
mutation ChangeName(\$scouter_name: String!, \$team_id: Int, \$schedule_id: Int) {
  update_scouting_shifts(where: {team_id: {_eq: \$team_id}, schedule_id: {_eq: \$schedule_id}}, _set: {scouter_name: \$scouter_name}) {
    affected_rows
  }
}

""";

Future<void> changeName(
  final String name,
  final int teamId,
  final int scheduleId,
) =>
    getClient().mutate(
      MutationOptions<void>(
        document: gql(changeScouterMutation),
        variables: <String, dynamic>{
          "scouter_name": name,
          "team_id": teamId,
          "schedule_id": scheduleId,
        },
      ),
    );

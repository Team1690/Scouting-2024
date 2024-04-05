import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";

String updateScouterMutation = """
mutation UpdateScouterName(\$old_scouter_name: String!, \$new_scouter_name: String!) {
  update_scouters(where: {scouter_name: {_eq: \$old_scouter_name}}, _set: {scouter_name: \$new_scouter_name}) {
    affected_rows
  }
  update_scouting_shifts(where: {scouter_name: {_eq: \$old_scouter_name}}, _set: {scouter_name: \$new_scouter_name}) {
    affected_rows
  }
}
""";

void updateScouter(final String oldScouterName, final String newScouterName) {
  getClient().mutate(
    MutationOptions<void>(
      document: gql(updateScouterMutation),
      variables: <String, dynamic>{
        "old_scouter_name": oldScouterName,
        "new_scouter_name": newScouterName,
      },
    ),
  );
}

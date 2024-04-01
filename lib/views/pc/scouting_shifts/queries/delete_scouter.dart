import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";

String deleteScouterMutation = """
mutation DeleteScouter(\$scouter_name: String!) {
  delete_scouters(where: {scouter_name: {_eq: \$scouter_name}}) {
    affected_rows
  }
}
""";

void deleteScouter(final String name) {
  getClient().mutate(
    MutationOptions<void>(
      document: gql(deleteScouterMutation),
      variables: <String, String>{
        "scouter_name": name,
      },
    ),
  );
}

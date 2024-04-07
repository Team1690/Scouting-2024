import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";

String deleteScouterMutation = """
mutation DeleteScouter {
  delete_scouting_shifts(where: {}) {
    affected_rows
  }
  delete_scouters(where: {}) {
    affected_rows
  }
}
""";

void deleteScouters() {
  getClient().mutate(
    MutationOptions<void>(
      document: gql(deleteScouterMutation),
    ),
  );
}

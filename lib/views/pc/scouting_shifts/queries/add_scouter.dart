import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";

String addScouterMutation = """
mutation MyMutation(\$scouter_name: String!) {
  insert_scouters(objects: {scouter_name: \$scouter_name}) {
    affected_rows
  }
}
""";

Future<void> addScouter(final String name) => getClient().mutate(
      MutationOptions<void>(
        document: gql(addScouterMutation),
        variables: <String, String>{
          "scouter_name": name,
        },
      ),
    );

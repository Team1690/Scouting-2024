import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";

Future<List<String>> fetchScouters() => getClient()
    .query(QueryOptions<List<String>>(
      document: gql(query),
      parserFn: (final Map<String, dynamic> data) {
        final List<dynamic> scouters = data["scouters"] as List<dynamic>;
        return scouters
            .map(
              (final dynamic scouter) => scouter["scouter_name"] as String,
            )
            .toList();
      },
    ))
    .then((final QueryResult<List<String>> value) => value.mapQueryResult());

String query = """
query FetchScouters {
  scouters {
    id
    scouter_name
  }
}
""";

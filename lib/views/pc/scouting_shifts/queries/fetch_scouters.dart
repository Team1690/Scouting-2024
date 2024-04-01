import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";

Stream<List<String>> fetchScouters() => getClient()
    .subscribe(
      SubscriptionOptions<List<String>>(
        document: gql(subscription),
        parserFn: (final Map<String, dynamic> data) {
          final List<dynamic> scouters = data["scouters"] as List<dynamic>;
          return scouters
              .map(
                (final dynamic scouter) => scouter["scouter_name"] as String,
              )
              .toList();
        },
      ),
    )
    .map(
      (final QueryResult<List<String>> event) => event.mapQueryResult(),
    );

String subscription = """
subscription FetchScouters {
  scouters {
    id
    scouter_name
  }
}

""";

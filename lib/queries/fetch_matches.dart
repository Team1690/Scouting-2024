import "package:graphql/client.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/queries/hasura_helper.dart";

const List<String> allianceMembers = <String>[
  "red_0",
  "red_1",
  "red_2",
  "red_3",
  "blue_0",
  "blue_1",
  "blue_2",
  "blue_3",
];
String graphqlSyntax(final bool isSubscription) => """
${isSubscription ? "subscription" : "query"} FetchMatches{
  schedule_matches(order_by:[{match_type:{order:asc}},{match_number:asc}]){
    ${allianceMembers.map(
          (final String e) => """$e{
      id
      name
      number
      colors_index
    }""",
        ).join("\n")}
    id
    match_type {
      title
      id
    }
    match_number
    happened
  }
}
  """;

List<LightTeam> alliancefromJson(final dynamic json, final String color) {
  final String optional = "${color}_3";
  return <LightTeam>[
    ...(<int>[0, 1, 2]
        .map((final int index) => LightTeam.fromJson(json["${color}_$index"]))),
    if (json[optional] != null) LightTeam.fromJson(json[optional]),
  ];
}

List<ScheduleMatch> Function(Map<String, dynamic>) parserFn(
  final IdTable<MatchType> matchType,
) =>
    (final Map<String, dynamic> matches) =>
        (matches["schedule_matches"] as List<dynamic>)
            .expand(
              (final dynamic e) => <ScheduleMatch>[
                ScheduleMatch.fromJson(e, false, matchType),
                ScheduleMatch.fromJson(e, true, matchType),
              ],
            )
            .toList();

Stream<List<ScheduleMatch>> fetchMatchesSubscription(
  final IdTable<MatchType> matchType,
) {
  final GraphQLClient client = getClient();
  final String subscription = graphqlSyntax(true);
  final Stream<QueryResult<List<ScheduleMatch>>> result = client.subscribe(
    SubscriptionOptions<List<ScheduleMatch>>(
      document: gql(subscription),
      parserFn: parserFn(matchType),
    ),
  );

  return result.map(
    (final QueryResult<List<ScheduleMatch>> event) => event.mapQueryResult(),
  );
}

Future<List<ScheduleMatch>> fetchMatches(
  final IdTable<MatchType> matchType,
) async {
  final GraphQLClient client = getClient();
  final String query = graphqlSyntax(false);
  final QueryResult<List<ScheduleMatch>> result = await client.query(
    QueryOptions<List<ScheduleMatch>>(
      document: gql(query),
      parserFn: parserFn(matchType),
    ),
  );
  return result.mapQueryResult();
}

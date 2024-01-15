import "package:graphql/client.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_widget.dart";

Stream<List<PickListTeam>> fetchPicklist() {
  final GraphQLClient client = getClient();
  //TODO update query
  const String query = """
 subscription My {
  team {
    colors_index
    first_picklist_index
    id
    name
    number
    second_picklist_index
    third_picklist_index
    taken
      
    }
}

    """;
  final Stream<QueryResult<List<PickListTeam>>> result = client.subscribe(
    SubscriptionOptions<List<PickListTeam>>(
      document: gql(query),
      parserFn: parse,
    ),
  );

  return result.map(
    (final QueryResult<List<PickListTeam>> event) => event.mapQueryResult(),
  );
}

List<PickListTeam> parse(final Map<String, dynamic> pickListTeams) {
  //TODO initialize variables from the query. note that you would need a validator like AmountOfMatches so that you can check if there are any matches played before grabbing data from technical matches.
  final List<PickListTeam> teams = (pickListTeams["team"] as List<dynamic>)
      .map(
        (final dynamic team) => PickListTeam(
          team: LightTeam.fromJson(team),
          firstListIndex: team["first_picklist_index"] as int,
          secondListIndex: team["second_picklist_index"] as int,
          thirdListIndex: team["third_picklist_index"] as int,
          taken: team["taken"] as bool,
        ),
      )
      .toList();
  return teams;
}

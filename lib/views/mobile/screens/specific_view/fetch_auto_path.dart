import "dart:collection";
import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_teams.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path_csv.dart";
import "package:http/http.dart" as http;

Future<List<String>> fetchUrls(final int team) async {
  final GraphQLClient client = getClient();
  const String query = r"""
query MyQuery($team: Int) {
  specific_match(where: {team_id: {_eq: $team}}, distinct_on: url) {
    url
  }
}
  """;
  final QueryResult<List<String>> result = await client.query(
    QueryOptions<List<String>>(
      document: gql(query),
      variables: <String, int>{"team": team},
      parserFn: parserFn,
    ),
  );
  return result.mapQueryResult();
}

List<String> parserFn(final Map<String, dynamic> urls) =>
    (urls["specific_match"] as List<dynamic>)
        .map((final dynamic url) => url["url"] as String)
        .toList();

Future<({List<ui.Offset> path, bool isRed})> fetchPath(
  final String? url,
) async {
  if (url == null || url.isEmpty) {
    return (path: <ui.Offset>[], isRed: false);
  }
  final String csv = await http.read(Uri.parse(url));
  return parseAutoCsv(csv);
}

Future<List<Sketch>> getPaths(final int teamId) async {
  final List<String> urls = (await fetchUrls(teamId)).toList();
  final List<Future<({List<ui.Offset> path, bool isRed})>> paths =
      urls.map(fetchPath).toList();

  final List<({bool isRed, List<ui.Offset> path})> pathResults =
      await Future.wait(paths);
  return pathResults
      .mapIndexed(
        (
          final int index,
          final ({bool isRed, List<ui.Offset> path}) element,
        ) =>
            Sketch(
          points: element.path,
          isRed: element.isRed,
          url: urls[index],
        ),
      )
      .toList();
}

Future<List<(TeamData, List<Sketch>)>> fetchDataAndPaths(
  final List<int> teamIds,
) async {
  final SplayTreeSet<TeamData> data = await fetchMultipleTeamData(teamIds);
  final List<List<Sketch>> paths = await Future.wait(
    data
        .map((final TeamData element) => getPaths(element.lightTeam.id))
        .toList(),
  );
  return paths
      .mapIndexed(
        (final int index, final List<Sketch> element) =>
            (data.elementAt(index), element),
      )
      .toList();
}

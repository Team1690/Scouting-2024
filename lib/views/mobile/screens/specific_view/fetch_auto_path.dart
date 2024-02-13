import "dart:collection";
import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_teams.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_data/starting_position_enum.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path_csv.dart";
import "package:http/http.dart" as http;

Future<List<(String, StartingPosition, MatchIdentifier)>> fetchUrls(
  final int team,
  final bool shouldDistinct,
) async {
  final GraphQLClient client = getClient();
  final String query = """
query MyQuery(\$team: Int) {
  specific_match(where: {team_id: {_eq: \$team}}${shouldDistinct ? ", distinct_on: url" : ""}) {
    url
    schedule_match {
      match_number
      match_type {
        title
      }
      id
      technical_matches(where: {team_id: {_eq: \$team}}) {
        starting_position {
          title
        }
      }
    }
    is_rematch
      
    }
  }


  """;
  final QueryResult<List<(String, StartingPosition, MatchIdentifier)>> result =
      await client.query(
    QueryOptions<List<(String, StartingPosition, MatchIdentifier)>>(
      document: gql(query),
      variables: <String, int>{"team": team},
      parserFn: parserFn,
    ),
  );
  return result.mapQueryResult();
}

List<(String, StartingPosition, MatchIdentifier)> parserFn(
  final Map<String, dynamic> urls,
) =>
    (urls["specific_match"] as List<dynamic>)
        .map((final dynamic url) {
          final bool validator =
              url["schedule_match"]["technical_matches"] != null &&
                  (url["schedule_match"]["technical_matches"] as List<dynamic>)
                      .isNotEmpty;
          return (url["schedule_match"]["technical_matches"] as List<dynamic>)
              .map(
            (final dynamic e) => validator
                ? (
                    url["url"] as String,
                    startingPosTitleToEnum(
                      e["starting_position"]["title"] as String,
                    ),
                    MatchIdentifier.fromJson(url, null)
                  )
                : null,
          );
        })
        .flattened
        .whereNotNull()
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

Future<
    List<
        ({
          Sketch sketch,
          StartingPosition startingPos,
          MatchIdentifier matchIdentifier
        })>> getPaths(
  final int teamId,
  final bool shouldDistinct,
) async {
  final List<(String, StartingPosition, MatchIdentifier)> urls =
      (await fetchUrls(teamId, shouldDistinct)).toList();
  final List<Future<({List<ui.Offset> path, bool isRed})>> paths = urls
      .map(
        (final (String, StartingPosition, MatchIdentifier) e) =>
            fetchPath(e.$1),
      )
      .toList();

  final List<({bool isRed, List<ui.Offset> path})> pathResults =
      await Future.wait(paths);
  return pathResults
      .mapIndexed(
        (
          final int index,
          final ({bool isRed, List<ui.Offset> path}) element,
        ) =>
            (
          sketch: Sketch(
            points: element.path,
            isRed: element.isRed,
            url: urls[index].$1,
          ),
          startingPos: urls[index].$2,
          matchIdentifier: urls[index].$3
        ),
      )
      .toList();
}

//TODO turn this into a model instead of a tuple within a tuple
Future<
    List<
        (
          TeamData,
          List<
              ({
                Sketch sketch,
                StartingPosition startingPos,
                MatchIdentifier matchIdentifier
              })>
        )>> fetchDataAndPaths(
  final BuildContext context,
  final List<int> teamIds,
) async {
  final SplayTreeSet<TeamData> data =
      await fetchMultipleTeamData(teamIds, context);
  final List<
      List<
          ({
            Sketch sketch,
            StartingPosition startingPos,
            MatchIdentifier matchIdentifier
          })>> paths = await Future.wait(
    data
        .map((final TeamData element) => getPaths(element.lightTeam.id, false))
        .toList(),
  );
  return paths
      .mapIndexed(
        (
          final int index,
          final List<
                  ({
                    Sketch sketch,
                    StartingPosition startingPos,
                    MatchIdentifier matchIdentifier
                  })>
              element,
        ) =>
            (data.elementAt(index), element),
      )
      .toList();
}

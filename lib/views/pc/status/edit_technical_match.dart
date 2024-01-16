import "package:flutter/material.dart";

import "package:graphql/client.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/match_model.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import 'package:scouting_frontend/views/mobile/screens/input_view/input_view.dart';
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class EditTechnicalMatch extends StatelessWidget {
  const EditTechnicalMatch({
    required this.matchIdentifier,
    required this.teamForQuery,
  });
  final MatchIdentifier matchIdentifier;
  final LightTeam teamForQuery;

  @override
  Widget build(final BuildContext context) => isPC(context)
      ? DashboardScaffold(body: editTechnicalMatch(context))
      : Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "${matchIdentifier.type} ${matchIdentifier.number}, team ${teamForQuery.number}",
            ),
          ),
          body: editTechnicalMatch(context),
        );
  FutureBuilder<Match> editTechnicalMatch(final BuildContext context) =>
      FutureBuilder<Match>(
        future: fetchTechnicalMatch(matchIdentifier, teamForQuery, context),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<Match> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return UserInput(snapshot.data);
          }
        },
      );
}

//TODO add new query here
const String query = """

""";

Future<Match> fetchTechnicalMatch(
  final MatchIdentifier matchIdentifier,
  final LightTeam teamForQuery,
  final BuildContext context,
) async {
  final GraphQLClient client = getClient();

  final QueryResult<Match> result = await client.query(
    QueryOptions<Match>(
      //TODO add json parsing and create a Match containing the data
      parserFn: (final Map<String, dynamic> technicalMatch) => Match(context),
      document: gql(query),
      variables: <String, dynamic>{
        "team_id": teamForQuery.id,
        "match_type_id":
            IdProvider.of(context).matchType.nameToId[matchIdentifier.type],
        "match_number": matchIdentifier.number,
        "is_rematch": matchIdentifier.isRematch,
      },
    ),
  );
  return result.mapQueryResult();
}

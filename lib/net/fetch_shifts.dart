import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

Future<List<ScoutingShift>> fetchShifts(final IdTable<MatchType> matchType) =>
    getClient()
        .query(QueryOptions<List<ScoutingShift>>(
          document: gql(query),
          parserFn: (final Map<String, dynamic> data) {
            final List<dynamic> shifts =
                data["scouting_shifts"] as List<dynamic>;
            return shifts
                .map(
                  (final dynamic shift) =>
                      ScoutingShift.fromJson(shift, matchType),
                )
                .toList();
          },
        ))
        .then((final QueryResult<List<ScoutingShift>> value) =>
            value.mapQueryResult());

String query = """
query FetchShifts {
  scouting_shifts {
    id
    scouter_name
    schedule_match {
      match_number
      match_type {
        id
      }
      id
    }
    team {
      colors_index
      id
      name
      number
    }
  }
}
""";

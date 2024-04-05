import "package:flutter/widgets.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

Stream<List<ScoutingShift>> fetchShiftsSubscription(
        final IdTable<MatchType> matchType) =>
    getClient()
        .subscribe(
          SubscriptionOptions<List<ScoutingShift>>(
            document: gql(subscription),
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
          ),
        )
        .map(
          (final QueryResult<List<ScoutingShift>> event) =>
              event.mapQueryResult(),
        );

String subscription = """
subscription FetchShifts {
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

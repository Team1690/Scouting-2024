import "dart:async";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/fault_status_enum.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/add_fault.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/fault_entry.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/fault_tile.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";

class FaultView extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => Scaffold(
        drawer: SideNavBar(),
        appBar: AppBar(
          title: const Text("Robot faults"),
          centerTitle: true,
          actions: <Widget>[
            AddFault(
              onFinished: handleQueryResult(context),
            ),
          ],
        ),
        body: StreamBuilder<List<(FaultEntry, int?)>>(
          stream: fetchFaults(context),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<List<(FaultEntry, int?)>> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return snapshot.data.mapNullable(
                    (final List<(FaultEntry, int?)> data) =>
                        SingleChildScrollView(
                      primary: false,
                      child: Column(
                        children: data
                            .map(
                              (final (FaultEntry, int?) e) => Card(
                                elevation: 2,
                                color: bgColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding / 4,
                                  ),
                                  child: FaultTile(e),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ) ??
                  (throw Exception("No data"));
            }
          },
        ),
      );
}

void Function(QueryResult<T>) handleQueryResult<T>(
  final BuildContext context,
) =>
    (final QueryResult<T> result) {
      ScaffoldMessenger.of(context).clearSnackBars();
      if (result.hasException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text("Error: ${result.exception}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    };

void showLoadingSnackBar(final BuildContext context) =>
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(days: 365),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        content: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    );

const List<String> teamValues = <String>[
  "blue_0",
  "blue_1",
  "blue_2",
  "blue_3",
  "red_0",
  "red_1",
  "red_2",
  "red_3",
];

Stream<List<(FaultEntry, int?)>> fetchFaults(final BuildContext context) {
  final GraphQLClient client = getClient();
  final Stream<QueryResult<List<(FaultEntry, int?)>>> result = client.subscribe(
    SubscriptionOptions<List<(FaultEntry, int?)>>(
      document: gql(subscription),
      parserFn: (final Map<String, dynamic> data) => (data["schedule_matches"]
              as List<dynamic>)
          .map(
            (final dynamic e) => (e["faults"] as List<dynamic>).map(
              (final dynamic fault) {
                final int lastMatch =
                    (data["schedule_matches"] as List<dynamic>).isNotEmpty
                        ? ScheduleMatch.fromJson(
                            (data["schedule_matches"] as List<dynamic>)
                                .lastWhereOrNull(
                              (final dynamic element) =>
                                  element["happened"] as bool,
                            ),
                            false,
                            IdProvider.of(context).matchType,
                          ).matchIdentifier.number
                        : 0;
                final dynamic nextMatch =
                    (data["schedule_matches"] as List<dynamic>)
                        .where(
                          (final dynamic element) => teamValues.any(
                            (final String team) =>
                                element[team]?["number"] == 1690 &&
                                element["match_type"]?["title"] != "Practice" &&
                                element["match_type"]?["title"] !=
                                    "Pre Scouting",
                          ),
                        )
                        .firstWhereOrNull(
                          (final dynamic element) => teamValues.any(
                            (final String team) =>
                                element[team]?["number"] ==
                                    LightTeam.fromJson(fault["team"]).number &&
                                !(element["happened"] as bool),
                          ),
                        );

                return (
                  FaultEntry.parse(fault, IdProvider.of(context)),
                  nextMatch == null
                      ? null
                      : ScheduleMatch.fromJson(
                            nextMatch,
                            false,
                            IdProvider.of(context).matchType,
                          ).matchIdentifier.number -
                          lastMatch
                );
              },
            ),
          )
          .flattened
          .sortedBy(
            (final (FaultEntry, int?) element) => element.$1.faultStatus.title,
          )
          .reversed
          .toList(),
    ),
  );
  return result.map(queryResultToParsed);
}

class NewFault {
  const NewFault(
    this.faultStatusEnum,
    this.message,
    this.teamId,
    this.scheduleMatchId,
    this.isRematch,
  );
  final FaultStatus faultStatusEnum;
  final String message;
  final int teamId;
  final int scheduleMatchId;
  final bool isRematch;
}

String subscription = """
subscription MyQuery {
  schedule_matches(order_by: {match_type: {order: asc}, match_number: asc}) {
    happened    
    faults(order_by: {fault_status: {order: asc}}) {
      fault_status {
        id
      title
    }
    id
    team {
      colors_index
      name
      number
      id
    }
    message
    schedule_match {
      happened
      match_type {
        id
        title
      }
      match_number
    }
    is_rematch
    
    }
    id
    happened
    match_number
    match_type {
      title
      id
    }
    ${teamValues.map(
          (final String e) => """$e{
      colors_index
      id
      name
      number
    
    }
    """,
        ).join(" ")}
  }
}
""";

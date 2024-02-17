import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/fault_status_enum.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/add_fault.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/fault_tile.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/mobile/screens/fault_entry.dart";

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
        body: StreamBuilder<List<FaultEntry>>(
          stream: fetchFaults(),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<List<FaultEntry>> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return snapshot.data.mapNullable(
                    (final List<FaultEntry> data) => SingleChildScrollView(
                      primary: false,
                      child: Column(
                        children: data
                            .map(
                              (final FaultEntry e) => Card(
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

Stream<List<FaultEntry>> fetchFaults() {
  final GraphQLClient client = getClient();
  final Stream<QueryResult<List<FaultEntry>>> result = client.subscribe(
    SubscriptionOptions<List<FaultEntry>>(
      document: gql(subscription),
      parserFn: (final Map<String, dynamic> data) =>
          (data["faults"] as List<dynamic>).map(FaultEntry.parse).toList(),
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

const String subscription = """
subscription MyQuery {
  faults(order_by: {fault_status: {order: asc}}) {
    fault_status {
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
      match_type {
        title
      }
      match_number
    }
    is_rematch
  }
}
""";

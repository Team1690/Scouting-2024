import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/models/team_data/all_team_data.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_all_teams.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/pc/picklist/picklist_card.dart";

class PickListScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => isPC(context)
      ? DashboardScaffold(
          body: pickList(context),
        )
      : Scaffold(
          appBar: AppBar(
            title: const Text("Picklist"),
            centerTitle: true,
          ),
          drawer: SideNavBar(),
          body: pickList(context),
        );

  Padding pickList(final BuildContext context) => Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: StreamBuilder<List<AllTeamData>>(
          stream: fetchAllTeams(),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<List<AllTeamData>> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return const Center(
                child: Text("No Teams"),
              );
            }
            return PicklistCard(
              initialData: snapshot.data!,
            );
          },
        ),
      );
}

void save(
  final List<AllTeamData> teams, [
  final BuildContext? context,
]) async {
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 5),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Saving", style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
  final GraphQLClient client = getClient();
  const String query = """
  mutation UpdatePicklist(\$objects: [team_insert_input!]!) {
  insert_team(objects: \$objects, on_conflict: {constraint: team_pkey, update_columns: [taken, first_picklist_index, second_picklist_index,third_picklist_index]}) {
    affected_rows
    returning {
      id
    }
  }
}

  """;

  final Map<String, dynamic> vars = <String, dynamic>{
    "objects": teams
        .map(
          (final AllTeamData e) => <String, dynamic>{
            "id": e.team.id,
            "name": e.team.name,
            "number": e.team.number,
            "colors_index": e.team.colorsIndex,
            "first_picklist_index": e.firstPicklistIndex,
            "second_picklist_index": e.secondPicklistIndex,
            "third_picklist_index": e.thirdPickListIndex,
            "taken": e.taken,
          },
        )
        .toList(),
  };

  final QueryResult<void> result = await client
      .mutate(MutationOptions<void>(document: gql(query), variables: vars));
  if (context != null) {
    if (result.hasException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text("Error: ${result.exception}"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Saved",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

enum CurrentPickList { first, second, third }

extension CurrentPickListExtension on CurrentPickList {
  T map<T>(
    final T Function() onFirst,
    final T Function() onSecond,
    final T Function() onThird,
  ) {
    switch (this) {
      case CurrentPickList.first:
        return onFirst();
      case CurrentPickList.second:
        return onSecond();
      case CurrentPickList.third:
        return onThird();
    }
  }

  int getIndex(final AllTeamData team) => map(
        () => team.firstPicklistIndex,
        () => team.secondPicklistIndex,
        () => team.thirdPickListIndex,
      );

  int setIndex(final AllTeamData team, final int index) => map(
        () => team.firstPicklistIndex = index,
        () => team.secondPicklistIndex = index,
        () => team.thirdPickListIndex = index,
      );
}

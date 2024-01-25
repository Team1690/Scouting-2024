import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_view.dart";

class TeamsWithoutPit extends StatelessWidget {
  const TeamsWithoutPit();

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Teams without pit"),
          centerTitle: true,
        ),
        body: StreamBuilder<List<LightTeam>>(
          stream: fetchTeamsWithoutPit(),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<List<LightTeam>> snapshot,
          ) =>
              snapshot.mapSnapshot<Widget>(
            onSuccess: (final List<LightTeam> teams) => ListView(
              children: teams
                  .map(
                    (final LightTeam team) => ListTile(
                      title: Text("${team.number} ${team.name}"),
                    ),
                  )
                  .toList(),
            ),
            onWaiting: () => const Center(
              child: CircularProgressIndicator(),
            ),
            onNoData: () => const Text("No Data"),
            onError: (final Object a) => Center(
              child: Text(snapshot.error.toString()),
            ),
          ),
        ),
      );
}

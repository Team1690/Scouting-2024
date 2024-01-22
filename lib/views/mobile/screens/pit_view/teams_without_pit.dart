import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
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
          ) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data.mapNullable(
                    (final List<LightTeam> teams) => teams
                        .map(
                          (final LightTeam team) => ListTile(
                            title: Text("${team.number} ${team.name}"),
                          ),
                        )
                        .toList(),
                  ) ??
                  (throw Exception("No data")),
            );
          },
        ),
      );
}

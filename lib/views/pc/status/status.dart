import "dart:collection";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_teams.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/pc/status/status_screen.dart";

class Status extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: StreamBuilder<SplayTreeSet<TeamData>>(
          stream: fetchMultipleTeamData(
            TeamProvider.of(context)
                .teams
                .map((final LightTeam team) => team.id)
                .toList(),
            context,
          ),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<SplayTreeSet<TeamData>> snapshot,
          ) =>
              snapshot.mapSnapshot(
            onSuccess: (final SplayTreeSet<TeamData> data) =>
                StatusScreen(data: data.toList()),
            onWaiting: () => const Center(
              child: CircularProgressIndicator(),
            ),
            onNoData: () => const Center(
              child: Text("No Data"),
            ),
            onError: (final Object error) => Text(error.toString()),
          ),
        ),
      );
}

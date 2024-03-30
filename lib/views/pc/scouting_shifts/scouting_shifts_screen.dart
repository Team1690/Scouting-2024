import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/fetch_shifts.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/widgets/edit_scouters_button.dart";

class ScoutingShiftsScreen extends StatelessWidget {
  const ScoutingShiftsScreen({super.key});

  //TODO: mapSnapshot needs a default value for nodata error and on waiting, so to get rid of duplicate code
  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: StreamBuilder<List<ScoutingShift>>(
          stream: fetchShifts(context),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<List<ScoutingShift>> snapshot,
          ) =>
              snapshot.mapSnapshot(
            onSuccess: (final List<ScoutingShift> data) => ListView(
              children: <Widget>[
                AppBar(
                  actions: const <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[EditScoutersButton()],
                    ),
                    Spacer()
                  ],
                  backgroundColor: bgColor,
                ),
                ...data.map(
                  (final ScoutingShift e) => ListTile(
                    title: Text(
                      "${e.name} ${e.team.number} ${e.matchIdentifier}",
                    ),
                  ),
                ),
              ],
            ),
            onWaiting: () => const Center(
              child: CircularProgressIndicator(),
            ),
            onNoData: () => const Text("No Data"),
            onError: (final Object error) => Center(
              child: Text(error.toString()),
            ),
          ),
        ),
      );
}

import "package:flutter/material.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/net/fetch_matches.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/blue_alliance_match_data.dart";
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/event_alert_dialog.dart";

class BlueAllianceCompareScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    late List<BlueAllianceMatchData>? blueAllianceMatches;
    return DashboardScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DashboardCard(
          title: "Blue Alliance Compare ",
          titleWidgets: <Widget>[
            IconButton(
              onPressed: () async {
                blueAllianceMatches =
                    await showDialog<List<BlueAllianceMatchData>?>(
                  context: context,
                  builder: (final BuildContext innerContext) =>
                      EventAlertDialog(),
                );
              },
              icon: const Icon(Icons.query_stats),
            ),
          ],
          body: StreamBuilder<List<ScheduleMatch>>(
            stream: fetchMatchesSubscription(IdProvider.of(context).matchType),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<List<ScheduleMatch>> snapshot,
            ) =>
                snapshot.mapSnapshot(
              onWaiting: () => const Center(
                child: CircularProgressIndicator(),
              ),
              onError: (final Object error) => Text(error.toString()),
              onNoData: () => const Center(
                child: Text("No data"),
              ),
              onSuccess: (final List<ScheduleMatch> data) => const Center(),
            ),
          ),
        ),
      ),
    );
  }
}

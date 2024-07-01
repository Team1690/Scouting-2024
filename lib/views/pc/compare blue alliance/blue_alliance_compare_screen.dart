import "package:flutter/material.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/blue_alliance_match.dart";
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/blue_alliance_match_data.dart";
import "package:scouting_frontend/views/pc/status/edit_technical_match.dart";

class BlueAllianceCompareScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    List<BlueAllianceMatchData>? blueAllianceMatches =
        <BlueAllianceMatchData>[];
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
          body: StreamBuilder<List<(BlueAllianceMatchData, List<String>)>>(
            stream: fetchAlliancesMatch(context),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<List<(BlueAllianceMatchData, List<String>)>>
                  snapshot,
            ) =>
                snapshot.mapSnapshot(
              onWaiting: () => const Center(
                child: CircularProgressIndicator(),
              ),
              onError: (final Object error) => Text(error.toString()),
              onNoData: () => const Center(
                child: Text("No data"),
              ),
              onSuccess: (
                final List<(BlueAllianceMatchData, List<String>)>
                    scoutingDataWithNames,
              ) {
                final List<(BlueAllianceMatchData, List<String>)> scoutingData =
                    scoutingDataWithNames
                        .where(
                          (
                            final (
                              BlueAllianceMatchData,
                              List<String>
                            ) matchAndName,
                          ) =>
                              blueAllianceMatches!
                                  .map(
                                    (final BlueAllianceMatchData match) =>
                                        match.matchNumber,
                                  )
                                  .toList()
                                  .contains(
                                    matchAndName.$1.matchNumber,
                                  ),
                        )
                        .toList();

                return Center(
                    child: ListView(
                  children: [
                    CompareMatches(
                        blueAllianceMatchData: blueAllianceMatches!,
                        scoutingAllianceData: scoutingAllianceData,
                        scouters: scouters),
                  ],
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CompareMatches extends StatelessWidget {
  const CompareMatches({
    super.key,
    required this.blueAllianceMatchData,
    required this.scoutingAllianceData,
    required this.scouters,
  });
  final List<BlueAllianceMatchData> blueAllianceMatchData;
  final List<BlueAllianceMatchData> scoutingAllianceData;
  final List<String> scouters;

  @override
  Widget build(final BuildContext context) {
    final List<BlueAllianceMatchData> blueAllianceData = blueAllianceMatchData
        .where(
          (
            final BlueAllianceMatchData matchAndName,
          ) =>
              scoutingAllianceData
                  .map(
                    (final BlueAllianceMatchData match) => match.matchNumber,
                  )
                  .toList()
                  .contains(
                    matchAndName.matchNumber,
                  ),
        )
        .toList();
    return const Row(
      children: <Widget>[],
    );
  }
}

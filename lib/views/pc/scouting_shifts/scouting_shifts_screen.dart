import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/providers/matches_provider.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/change_scouter.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/initial_scouters.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/delete_all_scouters.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/fetch_scouters.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/fetch_shifts.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/widgets/edit_scouters_button.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/widgets/export_csv_button.dart";

class ScoutingShiftsScreen extends StatefulWidget {
  const ScoutingShiftsScreen({super.key});

  @override
  State<ScoutingShiftsScreen> createState() => _ScoutingShiftsScreenState();
}

class _ScoutingShiftsScreenState extends State<ScoutingShiftsScreen> {
  List<String> scouters = <String>[];
  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: Expanded(
          child: StreamBuilder<List<String>>(
            stream: fetchScouters(),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<List<String>> snapshot,
            ) =>
                snapshot.mapSnapshot(
              onSuccess: (final List<String> scouterData) {
                if (scouterData.isEmpty) return const InitialScouters();
                scouters = scouterData;
                return StreamBuilder<List<ScoutingShift>>(
                  stream:
                      fetchShiftsSubscription(IdProvider.of(context).matchType),
                  builder: (
                    final BuildContext context,
                    final AsyncSnapshot<List<ScoutingShift>> snapshot,
                  ) =>
                      snapshot.mapSnapshot(
                    onSuccess: (final List<ScoutingShift> rawShiftData) {
                      final List<List<ScoutingShift>> shiftData = rawShiftData
                          .groupListsBy(
                            (final ScoutingShift element) =>
                                element.matchIdentifier,
                          )
                          .values
                          .sorted((
                        final List<ScoutingShift> a,
                        final List<ScoutingShift> b,
                      ) {
                        final int cmp =
                            a.first.matchIdentifier.type.order.compareTo(
                          b.first.matchIdentifier.type.order,
                        );
                        if (cmp != 0) return cmp;
                        return a.first.matchIdentifier.number.compareTo(
                          b.first.matchIdentifier.number,
                        );
                      });
                      return ListView(
                        children: <Widget>[
                          AppBar(
                            actions: <Widget>[
                              const EditScoutersButton(),
                              ExportCSVButton(
                                shifts: shiftData,
                              ),
                              const IconButton(
                                onPressed: deleteScouters,
                                icon: Icon(Icons.delete),
                              ),
                              const Spacer(),
                            ],
                            backgroundColor: bgColor,
                          ),
                          DataTable(
                            columns: const <DataColumn>[
                              DataColumn(label: Text("Match")),
                              DataColumn(label: Text("R1")),
                              DataColumn(label: Text("R2")),
                              DataColumn(label: Text("R3")),
                              DataColumn(label: Text("B1")),
                              DataColumn(label: Text("B2")),
                              DataColumn(label: Text("B3")),
                            ],
                            rows: <DataRow>[
                              ...shiftData.map(
                                (final List<ScoutingShift> e) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text(e.first.matchIdentifier.toString()),
                                    ),
                                    ...e.sorted((
                                      final ScoutingShift a,
                                      final ScoutingShift b,
                                    ) {
                                      final List<ScheduleMatch> matches =
                                          MatchesProvider.of(context).matches;
                                      final ScheduleMatch match =
                                          matches.firstWhere(
                                        (final ScheduleMatch element) =>
                                            element.matchIdentifier ==
                                            a.matchIdentifier,
                                      );
                                      final bool cmp = match.blueAlliance
                                              .contains(a.team) &&
                                          match.redAlliance.contains(b.team);
                                      final bool same = match.blueAlliance
                                                  .contains(a.team) &&
                                              match.blueAlliance
                                                  .contains(b.team) ||
                                          match.redAlliance.contains(a.team) &&
                                              match.redAlliance
                                                  .contains(b.team);
                                      if (same) {
                                        return a.team.number
                                            .compareTo(b.team.number);
                                      }
                                      return cmp ? 1 : -1;
                                    }).map(
                                      (final ScoutingShift e) => DataCell(
                                        onDoubleTap: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (final BuildContext context) =>
                                                    ChangeScouter(
                                              scouters: scouters,
                                              scoutingShift: e,
                                            ),
                                          );
                                        },
                                        Text(
                                          "${e.name} ${e.team.number} ",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    onWaiting: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    onNoData: () => const Text("No Data"),
                    onError: (final Object error) => Center(
                      child: Text(error.toString()),
                    ),
                  ),
                );
              },
              onWaiting: () => const Center(
                child: CircularProgressIndicator(),
              ),
              onNoData: () => const Text("No Data"),
              onError: (final Object error) => Center(
                child: Text(error.toString()),
              ),
            ),
          ),
        ),
      );
}

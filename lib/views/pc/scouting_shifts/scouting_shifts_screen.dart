import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/functions/calc_shifts.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/initial_scouters.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/fetch_scouters.dart";
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
              onSuccess: (final List<String> data) {
                if (data.isEmpty) return const InitialScouters();
                scouters = data;
                return ListView(
                  children: <Widget>[
                    AppBar(
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            const EditScoutersButton(),
                            ExportCSVButton(
                              scouters: scouters,
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                      backgroundColor: bgColor,
                    ),
                    ...calcScoutingShifts(context, data).slices(6).map(
                          (final List<ScoutingShift> e) => ListTile(
                            title: Row(
                              children: <Widget>[
                                Text(
                                  "${e.first.matchIdentifier.toString()} : ",
                                ),
                                ...e.map(
                                  (final ScoutingShift e) => Text(
                                    "${e.name} ${e.team.number} ,,, ",
                                  ),
                                ),
                              ],
                            ),
                          ),
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
          ),
        ),
      );
}

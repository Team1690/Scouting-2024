import "package:flutter/material.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_all_teams.dart";
import "package:scouting_frontend/models/team_data/all_team_data.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class TeamList extends StatelessWidget {
  const TeamList();

  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: StreamBuilder<List<AllTeamData>>(
            stream: fetchAllTeams(),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<List<AllTeamData>> snapshot,
            ) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              int? sortedColumn;
              bool isAscending = false;
              return snapshot.data.mapNullable(
                    (final List<AllTeamData> data) => StatefulBuilder(
                      builder: (
                        final BuildContext context,
                        final void Function(void Function()) setState,
                      ) {
                        num reverseUnless<T extends num>(
                          final bool condition,
                          final T x,
                        ) =>
                            condition ? x : -x;

                        DataColumn column(
                          final String title,
                          final num Function(AllTeamData) f, [
                          final String? toolTip,
                        ]) =>
                            DataColumn(
                              tooltip: toolTip,
                              label: Text(title),
                              numeric: true,
                              onSort: (final int index, final __) {
                                setState(() {
                                  isAscending =
                                      sortedColumn == index && !isAscending;
                                  sortedColumn = index;
                                  data.sort(
                                    (
                                      final AllTeamData a,
                                      final AllTeamData b,
                                    ) =>
                                        reverseUnless(
                                      isAscending,
                                      f(a).compareTo(f(b)),
                                    ).toInt(),
                                  );
                                });
                              },
                            );
                        return DashboardCard(
                          title: "Team list",
                          body: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            primary: false,
                            child: SingleChildScrollView(
                              primary: false,
                              child: DataTable(
                                sortColumnIndex: sortedColumn,
                                sortAscending: isAscending,
                                columns: <DataColumn>[
                                  const DataColumn(
                                    label: Text("Team number"),
                                    numeric: true,
                                  ),
                                  column(
                                    "Auto Gamepieces",
                                    (final AllTeamData team) => team
                                        .aggregateData.avgData.autoGamepieces,
                                  ),
                                  column(
                                    "Tele Gamepieces",
                                    (final AllTeamData team) => team
                                        .aggregateData.avgData.teleGamepieces,
                                  ),
                                  column(
                                    "Gamepieces Scored",
                                    (final AllTeamData team) =>
                                        team.aggregateData.avgData.gamepieces,
                                  ),
                                  column(
                                    "Gamepieces Missed",
                                    (final AllTeamData team) =>
                                        team.aggregateData.avgData.totalMissed,
                                  ),
                                  column(
                                    "Gamepiece points",
                                    (final AllTeamData team) => team
                                        .aggregateData.avgData.gamePiecesPoints,
                                  ),
                                  column(
                                    "Climbing Points",
                                    (final AllTeamData team) => team
                                        .aggregateData.avgData.climbingPoints,
                                    "Without Harmony",
                                  ),
                                  column(
                                    "Climbing Percentage",
                                    (final AllTeamData team) =>
                                        team.climbPercentage,
                                  ),
                                  column(
                                    "Broken matches",
                                    (final AllTeamData team) =>
                                        team.brokenMatches,
                                  ),
                                ],
                                rows: <DataRow>[
                                  ...data.map(
                                    (final AllTeamData team) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    15.0,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: team.team.color,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  team.team.number.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...<double>[
                                          team.aggregateData.avgData
                                              .autoGamepieces,
                                          team.aggregateData.avgData
                                              .teleGamepieces,
                                          team.aggregateData.avgData.gamepieces,
                                          team.aggregateData.avgData
                                              .totalMissed,
                                          team.aggregateData.avgData
                                              .gamePiecesPoints,
                                        ].map(show),
                                        DataCell(
                                          Text(
                                            team.aggregateData.avgData
                                                .climbingPoints
                                                .toStringAsFixed(1),
                                          ),
                                        ),
                                        show(team.climbPercentage, true),
                                        DataCell(
                                          Text(
                                            team.brokenMatches.toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ) ??
                  (throw Exception("No data"));
            },
          ),
        ),
      );
}

DataCell show(final double value, [final bool isPercent = false]) => DataCell(
      Text(
        value.isNaN
            ? "No data"
            : "${value.toStringAsFixed(2)}${isPercent ? "%" : ""}",
      ),
    );

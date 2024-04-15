import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";
import "package:scouting_frontend/models/data/specific_match_data.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_all_teams.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/scouting_specific.dart";
import "package:scouting_frontend/views/pc/team_list/aggregate_type.dart";
import "package:scouting_frontend/views/pc/team_list/show.dart";

class TeamList extends StatelessWidget {
  const TeamList();
  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: StreamBuilder<List<AllTeamData>>(
            stream: fetchAllTeams(context),
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
                        DataColumn boolColumn(
                          final String title,
                          final bool Function(AllTeamData) f, [
                          final String? toolTip,
                        ]) =>
                            DataColumn(
                              tooltip: toolTip,
                              label: Text(title),
                              numeric: true,
                            );
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
                                  data.sort((
                                    final AllTeamData a,
                                    final AllTeamData b,
                                  ) {
                                    final bool aHasData = f(a).isFinite;
                                    final bool bHasData = f(b).isFinite;

                                    if (!aHasData && !bHasData) {
                                      return 0;
                                    } else if (!aHasData) {
                                      return 1;
                                    } else if (!bHasData) {
                                      return -1;
                                    } else {
                                      return reverseUnless(
                                        isAscending,
                                        f(a).compareTo(f(b)),
                                      ).toInt();
                                    }
                                  });
                                });
                              },
                            );

                        List<DataColumn> columnList(final AggregateType type) =>
                            <DataColumn>[
                              column(
                                "${type.title} Auto Gamepieces",
                                (final AllTeamData team) =>
                                    type.data(team).autoGamepieces,
                                type.title,
                              ),
                              column(
                                "${type.title} Tele Gamepieces",
                                (final AllTeamData team) =>
                                    type.data(team).teleGamepieces,
                                type.title,
                              ),
                              column(
                                "${type.title} Gamepieces Scored",
                                (final AllTeamData team) =>
                                    type.data(team).gamepieces,
                                type.title,
                              ),
                              column(
                                "${type.title} Gamepieces brought to wing",
                                (final AllTeamData team) =>
                                    type.data(team).delivery,
                                type.title,
                              ),
                              column(
                                "${type.title} Total Gamepieces",
                                (final AllTeamData team) =>
                                    type.data(team).gamepiecesWthDelivery,
                                type.title,
                              ),
                              column(
                                "${type.title} Gamepieces Missed",
                                (final AllTeamData team) =>
                                    type.data(team).totalMissed,
                                type.title,
                              ),
                              column(
                                "${type.title} Gamepiece points",
                                (final AllTeamData team) =>
                                    type.data(team).gamePiecesPoints,
                                type.title,
                              ),
                              column(
                                "${type.title} Climbing Points",
                                (final AllTeamData team) =>
                                    type.data(team).climbingPoints,
                                "${type.title} Without Harmony",
                              ),
                            ];

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
                                  ...columnList(AggregateType.median),
                                  ...columnList(AggregateType.max),
                                  ...columnList(AggregateType.min),
                                  // Other
                                  column(
                                    "Climbing Percentage",
                                    (final AllTeamData team) =>
                                        team.climbPercentage,
                                  ),
                                  boolColumn(
                                    "Harmony",
                                    (final AllTeamData team) => team.harmony,
                                  ),
                                  column(
                                    "Broken matches",
                                    (final AllTeamData team) =>
                                        team.brokenMatches,
                                  ),

                                  column(
                                    "Speaker Rating",
                                    (final AllTeamData p0) =>
                                        p0.specificMatches
                                            .map(
                                              (final SpecificMatchData e) =>
                                                  e.speaker,
                                            )
                                            .whereNotNull()
                                            .toList()
                                            .averageOrNull ??
                                        double.nan,
                                  ),
                                  column(
                                    "Amp Rating",
                                    (final AllTeamData p0) =>
                                        p0.specificMatches
                                            .map(
                                              (final SpecificMatchData e) =>
                                                  e.amp,
                                            )
                                            .whereNotNull()
                                            .toList()
                                            .averageOrNull ??
                                        double.nan,
                                  ),
                                  column(
                                    "Climb Rating",
                                    (final AllTeamData p0) =>
                                        p0.specificMatches
                                            .map(
                                              (final SpecificMatchData e) =>
                                                  e.climb,
                                            )
                                            .whereNotNull()
                                            .toList()
                                            .averageOrNull ??
                                        double.nan,
                                  ),
                                  column(
                                    "Defense Rating",
                                    (final AllTeamData p0) =>
                                        p0.specificMatches
                                            .map(
                                              (final SpecificMatchData e) =>
                                                  e.defense,
                                            )
                                            .whereNotNull()
                                            .toList()
                                            .averageOrNull ??
                                        double.nan,
                                  ),
                                  column(
                                    "Drive Rating",
                                    (final AllTeamData p0) =>
                                        p0.specificMatches
                                            .map(
                                              (final SpecificMatchData e) =>
                                                  e.drivetrainAndDriving,
                                            )
                                            .whereNotNull()
                                            .toList()
                                            .averageOrNull ??
                                        double.nan,
                                  ),
                                  column(
                                    "Intake Rating",
                                    (final AllTeamData p0) =>
                                        p0.specificMatches
                                            .map(
                                              (final SpecificMatchData e) =>
                                                  e.intake,
                                            )
                                            .whereNotNull()
                                            .toList()
                                            .averageOrNull ??
                                        double.nan,
                                  ),
                                  column(
                                    "General Rating",
                                    (final AllTeamData p0) =>
                                        p0.specificMatches
                                            .map(
                                              (final SpecificMatchData e) =>
                                                  e.general,
                                            )
                                            .whereNotNull()
                                            .toList()
                                            .averageOrNull ??
                                        double.nan,
                                  ),
                                ],
                                rows: <DataRow>[
                                  ...data.map(
                                    (final AllTeamData team) {
                                      final List<DataCell> cells2 = <DataCell>[
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
                                          team.aggregateData.medianData
                                              .autoGamepieces,
                                          team.aggregateData.medianData
                                              .teleGamepieces,
                                          team.aggregateData.medianData
                                              .gamepieces,
                                          team.aggregateData.medianData
                                              .delivery,
                                          team.aggregateData.medianData
                                              .gamepiecesWthDelivery,
                                          team.aggregateData.medianData
                                              .totalMissed,
                                          team.aggregateData.medianData
                                              .gamePiecesPoints,
                                          team.aggregateData.medianData
                                              .climbingPoints,
                                        ].map(show),
                                        ...<int>[
                                          team.aggregateData.maxData
                                              .autoGamepieces,
                                          team.aggregateData.maxData
                                              .teleGamepieces,
                                          team.aggregateData.maxData.gamepieces,
                                          team.aggregateData.maxData.delivery,
                                          team.aggregateData.maxData
                                              .gamepiecesWthDelivery,
                                          team.aggregateData.maxData
                                              .totalMissed,
                                          team.aggregateData.maxData
                                              .gamePiecesPoints,
                                          team.aggregateData.maxData
                                              .climbingPoints,
                                        ].map(show),
                                        ...<int>[
                                          team.aggregateData.minData
                                              .autoGamepieces,
                                          team.aggregateData.minData
                                              .teleGamepieces,
                                          team.aggregateData.minData.gamepieces,
                                          team.aggregateData.minData.delivery,
                                          team.aggregateData.minData
                                              .gamepiecesWthDelivery,
                                          team.aggregateData.minData
                                              .totalMissed,
                                          team.aggregateData.minData
                                              .gamePiecesPoints,
                                          team.aggregateData.minData
                                              .climbingPoints,
                                        ].map(show),
                                        show(team.climbPercentage, true),
                                        DataCell(
                                          Text("${team.harmony}"),
                                        ),
                                        show(team.brokenMatches),
                                        DataCell(
                                          Text(
                                            getRating(
                                              team.specificMatches
                                                      .map(
                                                        (
                                                          final SpecificMatchData
                                                              e,
                                                        ) =>
                                                            e.speaker,
                                                      )
                                                      .whereNotNull()
                                                      .toList()
                                                      .averageOrNull ??
                                                  -1,
                                            ).letter,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            getRating(
                                              team.specificMatches
                                                      .map(
                                                        (
                                                          final SpecificMatchData
                                                              e,
                                                        ) =>
                                                            e.amp,
                                                      )
                                                      .whereNotNull()
                                                      .toList()
                                                      .averageOrNull ??
                                                  -1,
                                            ).letter,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            getRating(
                                              team.specificMatches
                                                      .map(
                                                        (
                                                          final SpecificMatchData
                                                              e,
                                                        ) =>
                                                            e.climb,
                                                      )
                                                      .whereNotNull()
                                                      .toList()
                                                      .averageOrNull ??
                                                  -1,
                                            ).letter,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            getRating(
                                              team.specificMatches
                                                      .map(
                                                        (
                                                          final SpecificMatchData
                                                              e,
                                                        ) =>
                                                            e.defense,
                                                      )
                                                      .whereNotNull()
                                                      .toList()
                                                      .averageOrNull ??
                                                  -1,
                                            ).letter,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            getRating(
                                              team.specificMatches
                                                      .map(
                                                        (
                                                          final SpecificMatchData
                                                              e,
                                                        ) =>
                                                            e.drivetrainAndDriving,
                                                      )
                                                      .whereNotNull()
                                                      .toList()
                                                      .averageOrNull ??
                                                  -1,
                                            ).letter,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            getRating(
                                              team.specificMatches
                                                      .map(
                                                        (
                                                          final SpecificMatchData
                                                              e,
                                                        ) =>
                                                            e.intake,
                                                      )
                                                      .whereNotNull()
                                                      .toList()
                                                      .averageOrNull ??
                                                  -1,
                                            ).letter,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            getRating(
                                              team.specificMatches
                                                      .map(
                                                        (
                                                          final SpecificMatchData
                                                              e,
                                                        ) =>
                                                            e.general,
                                                      )
                                                      .whereNotNull()
                                                      .toList()
                                                      .averageOrNull ??
                                                  -1,
                                            ).letter,
                                          ),
                                        ),
                                      ];
                                      return DataRow(
                                        cells: cells2,
                                      );
                                    },
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

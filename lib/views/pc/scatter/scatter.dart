import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_all_teams.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/constants.dart";

enum ScatterType {
  scored("Scored"),
  cycleScore("Cycle Score");

  const ScatterType(this.title);

  final String title;
}

class Scatter extends StatefulWidget {
  @override
  State<Scatter> createState() => _ScatterState();
}

class _ScatterState extends State<Scatter> {
  ScatterType currentGraph = ScatterType.cycleScore;
  bool normalize = false;
  late final Stream<List<AllTeamData>> stream = fetchAllTeams(context);
  String? highlight;

  @override
  Widget build(final BuildContext context) {
    String? tooltip;
    return DashboardCard(
      title: "",
      titleWidgets: <Widget>[
        SizedBox(
          width: 100,
          child: TextField(
            onChanged: (final String value) {
              setState(() {
                if (value.isNotEmpty && int.tryParse(value) != null) {
                  highlight = value;
                } else {
                  highlight = null;
                }
              });
            },
          ),
        ),
        ToggleButtons(
          children: ScatterType.values
              .map(
                (final ScatterType type) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Text(type.title),
                ),
              )
              .toList(),
          isSelected: ScatterType.values
              .map((final ScatterType e) => e == currentGraph)
              .toList(),
          onPressed: (final int pressedIndex) {
            setState(() {
              currentGraph = ScatterType.values[pressedIndex];
            });
          },
        ),
        IconButton(
          onPressed: () {
            setState(() {
              normalize = !normalize;
            });
          },
          icon: const Icon(Icons.auto_fix_normal),
        ),
      ],
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: StreamBuilder<List<AllTeamData>>(
              stream: stream,
              builder: (
                final BuildContext context,
                final AsyncSnapshot<List<AllTeamData>> snapshot,
              ) =>
                  snapshot.mapSnapshot(
                onSuccess: (final List<AllTeamData> data) {
                  final List<AllTeamData> report = data
                      .where(
                        (final AllTeamData element) =>
                            element.technicalMatches.isNotEmpty,
                      )
                      .toList();
                  if (report.isEmpty) {
                    return const Text("No data");
                  }
                  final List<LightTeam> teams = report
                      .map(
                        (final AllTeamData e) => e.team,
                      )
                      .toList();
                  return ScatterChart(
                    ScatterChartData(
                      scatterSpots: report.map(
                        (final AllTeamData e) {
                          final color = highlight == null ||
                                  e.team.number
                                      .toString()
                                      .startsWith(highlight!)
                              ? e.team.color
                              : Colors.grey.withAlpha(70);

                          return switch (currentGraph) {
                            ScatterType.cycleScore => ScatterSpot(
                                normalize
                                    ? e.aggregateData.avgData.cycleScore -
                                        e.aggregateData.meanDeviationData
                                            .cycleScore
                                    : e.aggregateData.avgData.cycleScore,
                                e.aggregateData.meanDeviationData.cycleScore,
                                color: color,
                              ),
                            ScatterType.scored => ScatterSpot(
                                normalize
                                    ? e.aggregateData.avgData.gamepieces -
                                        e.aggregateData.meanDeviationData
                                            .gamepieces
                                    : e.aggregateData.avgData.gamepieces,
                                e.aggregateData.meanDeviationData.gamepieces,
                                color: color,
                              )
                          };
                        },
                      ).toList(),
                      scatterTouchData: ScatterTouchData(
                        touchCallback: (
                          final FlTouchEvent event,
                          final ScatterTouchResponse? response,
                        ) {
                          if (response?.touchedSpot != null) {
                            tooltip = teams[response!.touchedSpot!.spotIndex]
                                .number
                                .toString();
                          }
                        },
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchTooltipData: ScatterTouchTooltipData(
                          tooltipBgColor: bgColor,
                          getTooltipItems: (final ScatterSpot touchedBarSpot) =>
                              ScatterTooltipItem(
                            tooltip!,
                            textStyle: const TextStyle(color: Colors.white),
                            bottomMargin: 10,
                          ),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameSize: 26,
                          axisNameWidget: switch (currentGraph) {
                            ScatterType.cycleScore => const Text(
                                "Average Cycle Score",
                              ),
                            ScatterType.scored =>
                              const Text("Average Gamepieces Scored")
                          },
                          sideTitles: SideTitles(
                            getTitlesWidget: (
                              final double title,
                              final TitleMeta meta,
                            ) =>
                                Container(
                              child: Text(title.toStringAsFixed(1)),
                            ),
                            showTitles: true,
                            interval: 5,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameSize: 26,
                          axisNameWidget: switch (currentGraph) {
                            ScatterType.cycleScore => const Text(
                                "Cycle score Standard Deviation",
                              ),
                            ScatterType.scored => const Text(
                                "gamepieces Scored Standard Deviation",
                              )
                          },
                          sideTitles: SideTitles(
                            getTitlesWidget: (
                              final double title,
                              final TitleMeta meta,
                            ) =>
                                Container(
                              child: Text(title.toStringAsFixed(1)),
                            ),
                            reservedSize: 22,
                            showTitles: true,
                            interval: 5,
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 5,
                        verticalInterval: 5,
                        drawHorizontalLine: true,
                        checkToShowHorizontalLine: (final double value) => true,
                        getDrawingHorizontalLine: (final double value) =>
                            FlLine(
                          color: Colors.black.withOpacity(0.1),
                        ),
                        drawVerticalLine: true,
                        checkToShowVerticalLine: (final double value) => true,
                        getDrawingVerticalLine: (final double value) => FlLine(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                      ),
                      minX: 0,
                      minY: 0,
                      maxX: report
                          .map(
                            (final AllTeamData e) => switch (currentGraph) {
                              ScatterType.cycleScore =>
                                (e.aggregateData.avgData.cycleScore + 1)
                                    .roundToDouble(),
                              ScatterType.scored =>
                                (e.aggregateData.avgData.gamepieces + 1)
                            },
                          )
                          .max,
                      maxY: report
                          .map(
                            (final AllTeamData e) => switch (currentGraph) {
                              ScatterType.cycleScore =>
                                (e.aggregateData.meanDeviationData.cycleScore +
                                        1)
                                    .roundToDouble(),
                              ScatterType.scored =>
                                (e.aggregateData.meanDeviationData.gamepieces +
                                        1)
                                    .roundToDouble()
                            },
                          )
                          .max,
                    ),
                  );
                },
                onWaiting: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                onNoData: () => const Center(
                  child: Text(
                    "No Data!",
                  ),
                ),
                onError: (final Object error) => Center(
                  child: Text(
                    "Error has happened in the future! $error",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

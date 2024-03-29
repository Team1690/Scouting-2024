import "dart:math";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_all_teams.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class Scatter extends StatefulWidget {
  @override
  State<Scatter> createState() => _ScatterState();
}

class _ScatterState extends State<Scatter> {
  bool isPoints = true;
  @override
  Widget build(final BuildContext context) {
    String? tooltip;
    return DashboardCard(
      title: "",
      titleWidgets: <Widget>[
        ToggleButtons(
          children: <Widget>[
            const Text("Points"),
            const Text("Sum"),
          ]
              .map(
                (final Widget text) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: text,
                ),
              )
              .toList(),
          isSelected: <bool>[isPoints, !isPoints],
          onPressed: (final int pressedIndex) {
            if (pressedIndex == 0) {
              setState(() {
                isPoints = true;
              });
            } else if (pressedIndex == 1) {
              setState(() {
                isPoints = false;
              });
            }
          },
        ),
      ],
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: StreamBuilder<List<AllTeamData>>(
              stream: fetchAllTeams(context),
              builder: (
                final BuildContext context,
                final AsyncSnapshot<List<AllTeamData>> snapshot,
              ) {
                if (snapshot.hasError) {
                  return Text(
                    "Error has happened in the future! ${snapshot.error}",
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return snapshot.data
                          .mapNullable((final List<AllTeamData> rawReport) {
                        final List<AllTeamData> report = rawReport
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
                            scatterSpots: report
                                .map(
                                  (final AllTeamData e) => isPoints
                                      ? ScatterSpot(
                                          e.aggregateData.avgData
                                              .gamePiecesPoints,
                                          e.aggregateData.meanDeviationData
                                              .gamePiecesPoints,
                                          color: e.team.color,
                                        )
                                      : ScatterSpot(
                                          e.aggregateData.avgData.gamepieces,
                                          e.aggregateData.meanDeviationData
                                              .gamepieces,
                                          color: e.team.color,
                                        ),
                                )
                                .toList(),
                            scatterTouchData: ScatterTouchData(
                              touchCallback: (
                                final FlTouchEvent event,
                                final ScatterTouchResponse? response,
                              ) {
                                if (response?.touchedSpot != null) {
                                  tooltip =
                                      teams[response!.touchedSpot!.spotIndex]
                                          .number
                                          .toString();
                                }
                              },
                              enabled: true,
                              handleBuiltInTouches: true,
                              touchTooltipData: ScatterTouchTooltipData(
                                tooltipBgColor: bgColor,
                                getTooltipItems:
                                    (final ScatterSpot touchedBarSpot) =>
                                        ScatterTooltipItem(
                                  tooltip!,
                                  textStyle:
                                      const TextStyle(color: Colors.white),
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
                                axisNameWidget: isPoints
                                    ? const Text(
                                        "Average gamepiece points",
                                      )
                                    : const Text("Average gamepieces"),
                                sideTitles: SideTitles(
                                  getTitlesWidget: (
                                    final double title,
                                    final TitleMeta meta,
                                  ) =>
                                      Container(child: Text(title.toString())),
                                  showTitles: true,
                                  interval: 5,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                axisNameSize: 26,
                                axisNameWidget: isPoints
                                    ? const Text(
                                        "Gamepiece points standard deviation",
                                      )
                                    : const Text(
                                        "Gamepieces standard deviation",
                                      ),
                                sideTitles: SideTitles(
                                  getTitlesWidget: (
                                    final double title,
                                    final TitleMeta meta,
                                  ) =>
                                      Container(child: Text(title.toString())),
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
                              checkToShowHorizontalLine: (final double value) =>
                                  true,
                              getDrawingHorizontalLine: (final double value) =>
                                  FlLine(color: Colors.black.withOpacity(0.1)),
                              drawVerticalLine: true,
                              checkToShowVerticalLine: (final double value) =>
                                  true,
                              getDrawingVerticalLine: (final double value) =>
                                  FlLine(color: Colors.black.withOpacity(0.1)),
                            ),
                            borderData: FlBorderData(
                              show: true,
                            ),
                            minX: 0,
                            minY: 0,
                            maxX: report
                                .map(
                                  (final AllTeamData e) => isPoints
                                      ? (e.aggregateData.avgData
                                                  .gamePiecesPoints +
                                              1)
                                          .roundToDouble()
                                      : (e.aggregateData.avgData.gamepieces + 1)
                                          .roundToDouble(),
                                )
                                .reduce(max),
                            maxY: report
                                .map(
                                  (final AllTeamData e) => isPoints
                                      ? (e.aggregateData.meanDeviationData
                                                  .gamePiecesPoints +
                                              1)
                                          .roundToDouble()
                                      : (e.aggregateData.meanDeviationData
                                                  .gamepieces +
                                              1)
                                          .roundToDouble(),
                                )
                                .fold<double>(25.0, max),
                          ),
                        );
                      }) ??
                      (throw Exception("No data"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

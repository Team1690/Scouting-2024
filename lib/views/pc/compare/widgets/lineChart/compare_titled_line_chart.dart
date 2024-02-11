import "dart:math";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";

class CompareClimbLineChart extends StatelessWidget {
  const CompareClimbLineChart({
    required this.colors,
    required this.data,
    required this.title,
    required this.teamDatas,
  });
  final List<List<int>> data;
  final List<TeamData> teamDatas;
  final List<Color> colors;
  final String title;
  @override
  Widget build(final BuildContext context) => Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(title),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
              top: 40,
            ),
            child: DashboardTitledLineChart(
              maxY: 1 +
                  Climb.values.fold(
                    0,
                    (final double previousValue, final Climb element) =>
                        max(previousValue, element.chartHeight),
                  ),
              minY: -1 +
                  Climb.values.fold(
                    0,
                    (final double previousValue, final Climb element) =>
                        min(previousValue, element.chartHeight),
                  ),
              heightsToTitles: <int, String>{
                for (final Climb climb in Climb.values)
                  climb.chartHeight.toInt(): climb.title,
              },
              robotMatchStatuses: teamDatas
                  .map(
                    (final TeamData teamData) => teamData.technicalMatches
                        .map((final TechnicalMatchData e) => e.robotFieldStatus)
                        .toList(),
                  )
                  .toList(),
              showShadow: false,
              inputedColors: colors,
              gameNumbers: List<MatchIdentifier>.generate(
                data
                    .map(
                      (final List<int> chartData) => chartData.length,
                    )
                    .reduce(max),
                (final int index) => MatchIdentifier(
                  number: index + 1,
                  type: MatchType.quals,
                  isRematch: false,
                ),
              ),
              dataSet: data
                  .map(
                    (final List<int> chartData) => chartData,
                  )
                  .toList(),
            ),
          ),
        ],
      );
}

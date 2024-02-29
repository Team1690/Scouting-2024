import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";

class CompareLineChart extends StatelessWidget {
  const CompareLineChart({
    required this.data,
    required this.colors,
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
            child: DashboardLineChart(
              robotMatchStatuses: teamDatas
                  .map(
                    (final TeamData teamData) => teamData.technicalMatches
                        .map((final TechnicalMatchData e) => e.robotFieldStatus)
                        .toList(),
                  )
                  .toList(),
              showShadow: false,
              inputedColors: colors,
              dataSet: data,
            ),
          ),
        ],
      );
}

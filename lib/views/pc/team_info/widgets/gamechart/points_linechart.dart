import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";

class PointsLineChart extends StatelessWidget {
  const PointsLineChart({
    required this.title,
    required this.data,
    required this.matches,
    this.color = Colors.green,
    this.sideTitlesInterval = 10,
  });

  final int Function(MatchData) data;
  final List<MatchData> matches;
  final String title;
  final Color color;
  final int sideTitlesInterval;

  @override
  Widget build(final BuildContext context) => Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
              top: 40,
            ),
            child: DashboardLineChart(
              sideTitlesInterval: sideTitlesInterval.toDouble(),
              showShadow: true,
              gameNumbers: matches.technicalMatchExists
                  .map(
                    (final MatchData e) => e.scheduleMatch.matchIdentifier,
                  )
                  .toList(),
              inputedColors: <Color>[
                color,
              ],
              dataSet: <List<int>>[
                matches.technicalMatchExists.map(data).toList(),
              ],
              robotMatchStatuses: <List<RobotFieldStatus>>[
                matches.technicalMatchExists
                    .map(
                      (final MatchData e) =>
                          e.technicalMatchData!.robotFieldStatus,
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      );
}

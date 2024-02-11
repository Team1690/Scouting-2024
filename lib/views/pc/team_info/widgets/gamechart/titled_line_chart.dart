import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";

class TitledLineChart extends StatelessWidget {
  const TitledLineChart({
    required this.heightToTitles,
    required this.matches,
    required this.data,
    required this.title,
  });

  final Map<int, String> heightToTitles;
  final List<MatchData> matches;
  final int Function(MatchData) data;
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
              left: 40.0,
              right: 20.0,
              top: 40,
            ),
            child: DashboardTitledLineChart(
              maxY: heightToTitles.keys.max.toDouble() + 1,
              minY: heightToTitles.keys.min.toDouble() - 1,
              showShadow: true,
              inputedColors: const <Color>[primaryColor],
              gameNumbers: matches.technicalMatchExists
                  .map((final MatchData e) => e.scheduleMatch.matchIdentifier)
                  .toList(),
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
              heightsToTitles: heightToTitles,
            ),
          ),
        ],
      );
}

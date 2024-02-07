import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/defense_amount_enum.dart";
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
              maxY: 2,
              minY: -1,
              showShadow: true,
              defenseAmounts: <List<DefenseAmount>>[
                matches.fullGames
                    .map(
                      (final MatchData e) => e.specificMatchData!.defenseAmount,
                    )
                    .toList(),
              ],
              inputedColors: const <Color>[primaryColor],
              gameNumbers: matches.fullGames
                  .map((final MatchData e) => e.scheduleMatch.matchIdentifier)
                  .toList(),
              dataSet: <List<int>>[matches.fullGames.map(data).toList()],
              robotMatchStatuses: <List<RobotFieldStatus>>[
                matches.fullGames
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

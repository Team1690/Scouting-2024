import "dart:math";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_match_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

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
              defenseAmounts: teamDatas
                  .map(
                    (final TeamData teamData) => teamData.specificMatches
                        .map((final SpecificMatchData e) => e.defenseAmount)
                        .toList(),
                  )
                  .toList(),
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
                data.map((final List<int> e) => e.length).reduce(max),
                (final int index) => MatchIdentifier(
                  number: index + 1,
                  type: "Quals",
                  isRematch: false,
                ),
              ),
              dataSet: data,
            ),
          ),
        ],
      );
}

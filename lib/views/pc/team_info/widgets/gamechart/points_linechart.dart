import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";

class PointsLineChart extends StatelessWidget {
  const PointsLineChart({
    required this.title,
    required this.data,
    required this.matches,
  });

  final int Function(MatchData) data;
  final List<List<MatchData>> matches;
  final String title;

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
              sideTitlesInterval: 10,
              showShadow: true,
              gameNumbers: matches
                  .map(
                    (final List<MatchData> e) => e.fullGames.map(
                        (final MatchData e) => e.scheduleMatch.matchIdentifier),
                  )
                  .expand(identity)
                  .toList(),
              inputedColors: const <Color>[
                Colors.green,
              ],
              distanceFromHighest: 20,
              dataSet: matches
                  .map(
                      (final List<MatchData> match) => match.map(data).toList())
                  .toList(),
              robotMatchStatuses: matches
                  .map((final List<MatchData> teamMatches) => teamMatches
                      .fullGames
                      .map((final MatchData match) =>
                          match.technicalMatchData!.robotFieldStatus)
                      .toList())
                  .toList(),
              defenseAmounts: matches
                  .map((final List<MatchData> teamMatches) => teamMatches
                      .fullGames
                      .map((final MatchData match) =>
                          match.specificMatchData!.defenseAmount)
                      .toList())
                  .toList(),
            ),
          ),
        ],
      );
}

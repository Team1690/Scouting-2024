import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/defense_amount_enum.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";
import "package:scouting_frontend/views/constants.dart";

class GamepiecesLineChart extends StatelessWidget {
  const GamepiecesLineChart({
    required this.title,
    required this.matches,
    required this.data,
  });

  final String title;
  final List<MatchData> matches;
  final int Function(MatchData) data;
  @override
  Widget build(final BuildContext context) => Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              const Spacer(),
              Align(
                alignment: const Alignment(-0.4, -1),
                child: Row(
                  children: <Widget>[
                    if (isPC(context)) ...<Widget>[
                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: " Full Defense ",
                              style: TextStyle(color: Colors.green),
                            ),
                            TextSpan(
                              text: " Half Defense ",
                              style: TextStyle(color: Colors.blue),
                            ),
                            TextSpan(
                              text: " Didnt Come ",
                              style: TextStyle(color: Colors.purple),
                            ),
                            TextSpan(
                              text: " Didnt Work ",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    RichText(
                      text: const TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: " Scored ",
                            style: TextStyle(color: Colors.green),
                          ),
                          TextSpan(
                            text: " Missed ",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 30.0,
              left: 20.0,
              right: 20.0,
              top: 30,
            ),
            child: DashboardLineChart(
              showShadow: false,
              gameNumbers: matches.fullGames
                  .map((final MatchData e) => e.scheduleMatch.matchIdentifier)
                  .toList(),
              inputedColors: const <Color>[
                Colors.green,
                Colors.red,
              ],
              distanceFromHighest: 4,
              dataSet: <List<int>>[matches.fullGames.map(data).toList()],
              robotMatchStatuses: <List<RobotFieldStatus>>[
                matches.fullGames
                    .map(
                      (final MatchData e) =>
                          e.technicalMatchData!.robotFieldStatus,
                    )
                    .toList(),
              ],
              defenseAmounts: <List<DefenseAmount>>[
                matches.fullGames
                    .map(
                      (final MatchData e) => e.specificMatchData!.defenseAmount,
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      );
}

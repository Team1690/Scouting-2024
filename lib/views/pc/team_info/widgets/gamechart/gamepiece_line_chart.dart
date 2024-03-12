import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";
import "package:scouting_frontend/views/constants.dart";

class GamepiecesLineChart extends StatelessWidget {
  const GamepiecesLineChart({
    super.key,
    required this.title,
    required this.matches,
    required this.data,
    this.missedData,
    this.deliveryData,
  });

  final String title;
  final List<MatchData> matches;
  final int Function(MatchData) data;
  final int Function(MatchData)? missedData;
  final int Function(MatchData)? deliveryData;
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
                              text: " Didnt Come ",
                              style: TextStyle(color: Colors.red),
                            ),
                            TextSpan(
                              text: " Didnt Work ",
                              style: TextStyle(color: Colors.purple),
                            ),
                            TextSpan(
                              text: " Did Defense ",
                              style: TextStyle(color: Colors.blue),
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
                          TextSpan(
                            text: " Delivered ",
                            style: TextStyle(color: Colors.yellow),
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
              gameNumbers: matches.technicalMatchExists
                  .map((final MatchData e) => e.scheduleMatch.matchIdentifier)
                  .toList(),
              inputedColors: const <Color>[
                Colors.green,
                Colors.red,
                Colors.yellow,
              ],
              distanceFromHighest: 4,
              dataSet: <List<int>>[
                matches.technicalMatchExists.map(data).toList(),
                if (missedData != null)
                  matches.technicalMatchExists.map(missedData!).toList(),
                if (deliveryData != null)
                  matches.technicalMatchExists.map(deliveryData!).toList(),
              ],
              robotMatchStatuses: <List<RobotFieldStatus>>[
                matches.technicalMatchExists
                    .map(
                      (final MatchData e) =>
                          e.technicalMatchData!.robotFieldStatus,
                    )
                    .toList(),
                matches.technicalMatchExists
                    .map(
                      (final MatchData e) =>
                          e.technicalMatchData!.robotFieldStatus,
                    )
                    .toList(),
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

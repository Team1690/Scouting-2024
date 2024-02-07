import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";
import "package:scouting_frontend/views/constants.dart";

class GamepiecesLineChart extends StatelessWidget {
  const GamepiecesLineChart(this.data);
  final LineChartData data;
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
              data.title,
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
              gameNumbers: data.gameNumbers,
              inputedColors: const <Color>[
                Colors.green,
                Colors.red,
              ],
              distanceFromHighest: 4,
              dataSet: data.points,
              robotMatchStatuses: data.robotMatchStatuses,
              defenseAmounts: data.defenseAmounts,
            ),
          ),
        ],
      );
}

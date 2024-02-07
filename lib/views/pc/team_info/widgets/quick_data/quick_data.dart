import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/card.dart";
import 'package:scouting_frontend/models/team_info_models/quick_data.dart';

class QuickDataCard extends StatelessWidget {
  const QuickDataCard(this.data);
  final QuickData data;
  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "Quick data",
        body: data.amoutOfMatches == 0
            ? Container(
                child: const Text("Not Enough Data :("),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const Text(
                            "Amp",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Avg Auto Amp: ${data.autoAmpAvg.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg Tele Amp: ${data.teleAmpAvg.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg Total Amp: ${(data.teleAmpAvg + data.autoAmpAvg).toStringAsFixed(1)}",
                          ),
                          Text(
                            "Max Total Amp: ${(data.bestAmpGamepiecesSum).toStringAsFixed(1)}",
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text(
                            "Speaker",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Avg Auto Speaker: ${data.autoSpeakerAvg.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg Tele Speaker: ${data.teleSpeakerAvg.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg Total Speaker: ${(data.teleSpeakerAvg + data.autoSpeakerAvg).toStringAsFixed(1)}",
                          ),
                          Text(
                            "Max Total Speaker: ${(data.bestSpeakerGamepiecesSum).toStringAsFixed(1)}",
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text(
                            "Misc",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Avg Gamepiece Points: ${data.gamepiecePoints.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg Gamepieces: ${data.gamepiecesScored.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Possible Traps: ${data.trapAmount ?? "No Data"}",
                          ),
                          Text(
                            "Avg Trap Amount: ${data.avgTrapAmount.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Trap Success Rate: ${data.trapSuccessRate.isNaN ? "No Data" : "${data.trapSuccessRate.toStringAsFixed(1)}%"}",
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text(
                            "Climb",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Climb Percentage: ${data.climbPercentage.isNaN ? "No Data" : data.climbPercentage.toStringAsFixed(1)}%",
                          ),
                          Text(
                            "Can Harmony: ${data.canHarmony ?? "No Data"}",
                          ),
                          Text(
                            "Matches Climbed 1: ${data.matchesClimbedSingle}",
                          ),
                          Text(
                            "Matches Climbed 2: ${data.matchesClimbedDouble}",
                          ),
                          Text(
                            "Matches Climbed 3: ${data.matchesClimbedTriple}",
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text(
                            "Defense Stats",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Avg GP Not Defending: ${data.avgGamepiecesNoDefense.isNaN ? "No Data" : data.avgGamepiecesNoDefense.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg GP Half Defending: ${data.avgGamepiecesHalfDefense.isNaN ? "No Data" : data.avgGamepiecesHalfDefense.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg GP Full Defending: ${data.avgGamepiecesFullDefense.isNaN ? "No Data" : data.avgGamepiecesFullDefense.toStringAsFixed(1)}",
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text(
                            "Picklist",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "1st Picklist Position: ${data.firstPicklistIndex + 1}",
                          ),
                          Text(
                            "2nd Picklist Position: ${data.secondPicklistIndex + 1}",
                          ),
                          Text(
                            "3rd Picklist Position: ${data.thirdPicklistIndex + 1}",
                          ),
                        ],
                      ),
                    ]
                        .expand(
                          (final Widget element) =>
                              <Widget>[element, const SizedBox(width: 40)],
                        )
                        .toList(),
                  ),
                ),
              ),
      );
}

import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/models/team_info_models/quick_data.dart";

class QuickDataCard extends StatelessWidget {
  const QuickDataCard({
    super.key,
    required this.data,
    this.direction = Axis.horizontal,
  });
  final QuickData data;
  final Axis direction;
  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "Quick data",
        body: data.amoutOfMatches == 0
            ? Container(
                child: const Text("Not Enough Data :("),
              )
            : SingleChildScrollView(
                scrollDirection: direction,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Flex(
                    direction: direction,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const Text(
                            "Amp",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Median Auto Amp: ${data.medianData.autoAmp.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Median Tele Amp: ${data.medianData.teleAmp.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Auto Amp: ${data.avgData.autoAmp.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Tele Amp: ${data.avgData.autoSpeaker.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Total Amp: ${(data.avgData.ampGamepieces).toStringAsFixed(2)}",
                          ),
                          Text(
                            "Max Total Amp: ${(data.maxData.ampGamepieces).toStringAsFixed(2)}",
                          ),
                          Text(
                            "Min Total Amp: ${data.minData.ampGamepieces.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Auto Amp Missed: ${data.avgData.autoAmpMissed.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Tele Amp Missed ${data.avgData.teleAmpMissed.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Median auto Amp Missed: ${data.medianData.autoAmpMissed.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Median Tele Amp Missed: ${data.medianData.teleAmpMissed.toStringAsFixed(2)}",
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
                            "Median Auto Speaker: ${data.medianData.autoSpeaker.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Median Tele Speaker: ${data.medianData.teleSpeaker.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Auto Speaker: ${data.avgData.autoSpeaker.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Tele Speaker: ${data.avgData.teleSpeaker.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Total Speaker: ${data.avgData.speakerGamepieces.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Max Total Speaker: ${(data.maxData.speakerGamepieces).toStringAsFixed(2)}",
                          ),
                          Text(
                            "Min Total Speaker: ${data.minData.speakerGamepieces.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Auto Speaker Missed: ${data.avgData.autoSpeakerMissed.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Tele Speaker Missed ${data.avgData.teleSpeakerMissed.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Median auto Speaker Missed: ${data.medianData.autoSpeakerMissed.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Median Tele Speaker Missed: ${data.medianData.teleSpeakerMissed.toStringAsFixed(2)}",
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
                            "Median Gamepiece Points: ${data.medianData.gamePiecesPoints.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Median Gamepiece: ${data.medianData.gamepieces.toStringAsFixed(1)}",
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
                            "Avg Trap Amount: ${data.avgData.trapAmount.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Trap Success Rate: ${data.trapSuccessRate.isNaN ? "No Data" : "${data.trapSuccessRate.toStringAsFixed(1)}%"}",
                          ),
                          Text(
                            "Median Trap Amount: ${data.medianData.trapAmount}",
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

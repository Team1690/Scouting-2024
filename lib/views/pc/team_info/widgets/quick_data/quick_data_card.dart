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
                    crossAxisAlignment: direction == Axis.horizontal
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const Text(
                            "Misc",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Avg Cycle Score: ${data.avgData.cycleScore.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg Gamepiece Points: ${data.avgData.gamePiecesPoints.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg Gamepieces Scored: ${data.avgData.gamepieces.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg Brought to wing: ${data.avgData.delivery.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Matches Played: ${data.amoutOfMatches.toStringAsFixed(1)}",
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text(
                            "Amp",
                            style: TextStyle(fontSize: 18),
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
                            "Avg Amp Missed ${data.avgData.missedAmp.toStringAsFixed(2)}",
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
                            "Avg Total Speaker: ${data.avgData.speakerGamepieces.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Max Total Speaker: ${(data.maxData.speakerGamepieces).toStringAsFixed(2)}",
                          ),
                          Text(
                            "Min Total Speaker: ${data.minData.speakerGamepieces.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Speaker Missed ${data.avgData.missedSpeaker.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text(
                            "Endgame",
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
                          Text(
                            "Avg Trap Amount: ${data.avgData.trapAmount.toStringAsFixed(1)}",
                          ),
                          Text(
                            "Avg Trap Missed: ${data.avgData.delivery.toStringAsFixed(1)}",
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

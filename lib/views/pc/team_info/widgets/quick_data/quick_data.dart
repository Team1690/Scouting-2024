import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class QuickDataCard extends StatelessWidget {
  const QuickDataCard(this.data);
  final QuickData data;
  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "Quick data",
        body: data.amoutOfMatches == 0
            ? Container(
                child: const Text("TODO :D"),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const Text(
                          "Auto",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Speaker: ${data.avgAutoSpeaker.toStringAsFixed(1)}",
                        ),
                        Text("Amp: ${data.avgAutoAmp.toStringAsFixed(1)}"),
                        Text(
                          "Missed Speaker: ${data.avgAutoMissedSpeaker.toStringAsFixed(1)}",
                        ),
                        Text(
                          "Missed Amp: ${data.avgAutoMissedAmp.toStringAsFixed(1)}",
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        const Text(
                          "Teleop",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Speaker: ${data.avgTeleSpeaker.toStringAsFixed(1)}",
                        ),
                        Text("Amp: ${data.avgTeleAmp.toStringAsFixed(1)}"),
                        Text(
                          "Missed Speaker: ${data.avgTeleMissedSpeaker.toStringAsFixed(1)}",
                        ),
                        Text(
                          "Missed Amp: ${data.avgTeleMissedAmp.toStringAsFixed(1)}",
                        ),
                        Text("Traps: ${data.avgTrap.toStringAsFixed(1)}"),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        const Text(
                          "Climb",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Games Climbed: ${data.matchesClimbed}",
                        ),
                        Text("Games Harmonized: ${data.matchesHarmonized}"),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        const Text(
                          "Points",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Gamepieces: ${data.avgGamepiecePoints.toStringAsFixed(1)}",
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
                          "Gamepieces scored: ${data.avgGamepieces.toStringAsFixed(1)}",
                        ),
                        Text("Matches Played: ${data.amoutOfMatches}"),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        const Text(
                          "Defense Stats",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Avg GP No Defense: ${data.avgGamePiecesNoDefense.toStringAsFixed(1)}",
                        ),
                        Text(
                          "Avg GP Half Defense: ${data.avgGamePiecesHalfDefense.toStringAsFixed(1)}",
                        ),
                        Text(
                          "Avg GP Full Defense: ${data.avgGamePiecesFullDefense.toStringAsFixed(1)}",
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        const Text(
                          "Picklist",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text("First: ${data.firstPicklistIndex}"),
                        Text("Second: ${data.secondPicklistIndex}"),
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
      );
}

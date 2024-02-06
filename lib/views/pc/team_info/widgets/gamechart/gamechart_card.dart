import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/enums/point_giver_enum.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/gamepiece_line_chart.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/points_linechart.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/titled_line_chart.dart";

class Gamechart extends StatelessWidget {
  const Gamechart(this.data);
  final TeamData data;
  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "Game Chart",
        body: data.technicalMatches.length < 2
            ? const Text("Not enough data for line chart")
            : CarouselWithIndicator(
                widgets: <Widget>[
                  GamepiecesLineChart(
                    getGamepieceChartData(
                      context,
                      <List<int>>[
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) => e.data.gamepieces,
                            )
                            .toList(),
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.data.totalMissed,
                            )
                            .toList(),
                      ],
                      "Total Gamepieces",
                    ),
                  ),
                  GamepiecesLineChart(
                    getGamepieceChartData(
                      context,
                      <List<int>>[
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.data.autoGamepieces,
                            )
                            .toList(),
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.data.autoSpeakerMissed +
                                  e.data.autoAmpMissed,
                            )
                            .toList(),
                      ],
                      "Auto Gamepieces",
                    ),
                  ),
                  GamepiecesLineChart(
                    getGamepieceChartData(
                      context,
                      <List<int>>[
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.data.speakerGamepieces,
                            )
                            .toList(),
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.data.autoSpeakerMissed +
                                  e.data.teleSpeakerMissed,
                            )
                            .toList(),
                      ],
                      "Total Speaker",
                    ),
                  ),
                  GamepiecesLineChart(
                    getGamepieceChartData(
                      context,
                      <List<int>>[
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.data.ampGamepieces,
                            )
                            .toList(),
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.data.autoAmpMissed + e.data.teleAmpMissed,
                            )
                            .toList(),
                      ],
                      "Total Amp",
                    ),
                  ),
                  PointsLineChart(
                    getGamepieceChartData(
                      context,
                      <List<int>>[
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.data.autoAmp * PointGiver.autoAmp.points +
                                  e.data.teleAmp * PointGiver.teleAmp.points +
                                  e.data.autoSpeaker *
                                      PointGiver.autoSpeaker.points +
                                  e.data.teleSpeaker *
                                      PointGiver.teleSpeaker.points,
                            )
                            .toList(),
                      ],
                      "Gamepiece Points",
                    ),
                  ),
                  TitledLineChart(
                    data: getTitledData(
                      context,
                      <List<int>>[
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData match) =>
                                  match.robotFieldStatus.name !=
                                          RobotFieldStatus.didntComeToField.name
                                      ? match.climb.title
                                      : Climb.noAttempt.title,
                            )
                            .toList()
                            .map<int>((final String title) {
                          switch (title) {
                            case "Failed":
                              return 0;
                            case "No Attempt":
                              return -1;
                            case "Climbed":
                              return 1;
                            case "Buddy Climbed":
                              return 2;
                          }
                          throw Exception("Not a climb value");
                        }).toList(),
                      ],
                      "Climb",
                    ),
                    heightToTitles: const <int, String>{
                      -1: "No Attempt",
                      0: "Failed",
                      1: "Climbed",
                      2: "Buddy Climbed",
                    },
                  ),
                  GamepiecesLineChart(
                    getGamepieceChartData(
                      context,
                      <List<int>>[
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) => e.data.trapAmount,
                            )
                            .toList(),
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.data.trapsMissed,
                            )
                            .toList(),
                      ],
                      "Trap Amount",
                    ),
                  ),
                ],
              ),
      );
  LineChartData getTitledData(
    final BuildContext context,
    final List<List<int>> points,
    final String title,
  ) =>
      LineChartData(
        gameNumbers: data.matches
            .where(
              (final MatchData element) => element.technicalMatchData != null,
            )
            .map((final MatchData e) => e.scheduleMatch.matchIdentifier)
            .toList(),
        points: points,
        title: title,
        robotMatchStatuses: List<List<RobotFieldStatus>>.filled(
          1,
          data.technicalMatches
              .map((final TechnicalMatchData match) => match.robotFieldStatus)
              .toList(),
        ),
        defenseAmounts: List<List<DefenseAmount>>.filled(
          1,
          data.technicalMatches
              .map(
                (final TechnicalMatchData match) => DefenseAmount
                    .noDefense, //defense should not be shown in Balance Charts
              )
              .toList(),
        ),
      );
  LineChartData getGamepieceChartData(
    final BuildContext context,
    final List<List<int>> selectedData,
    final String title,
  ) =>
      LineChartData(
        gameNumbers: data.matches
            .map((final MatchData e) => e.scheduleMatch.matchIdentifier)
            .toList(),
        points: selectedData,
        title: title,
        robotMatchStatuses: List<List<RobotFieldStatus>>.filled(
          2,
          data.technicalMatches
              .map((final TechnicalMatchData match) => match.robotFieldStatus)
              .toList(),
        ),
        defenseAmounts: List<List<DefenseAmount>>.filled(
          2,
          data.technicalMatches
              .map(
                (final TechnicalMatchData match) => DefenseAmount
                    .noDefense, //TODO add integration with specific for getting defenseAmount
              )
              .toList(),
        ),
      );
}

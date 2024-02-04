import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/fetch_functions/climb_enum.dart";
import "package:scouting_frontend/views/common/fetch_functions/parse_match_functions.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
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
                            .map((final TechnicalMatchData e) => e.gamepieces)
                            .toList(),
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.autoSpeakerMissed +
                                  e.teleSpeakerMissed +
                                  e.autoAmpMissed +
                                  e.teleAmpMissed,
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
                              (final TechnicalMatchData e) => e.autoGamepieces,
                            )
                            .toList(),
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.autoSpeakerMissed + e.autoAmpMissed,
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
                                  e.autoSpeaker + e.teleSpeaker,
                            )
                            .toList(),
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.autoSpeakerMissed + e.teleSpeakerMissed,
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
                                  e.autoAmp + e.teleAmp,
                            )
                            .toList(),
                        data.technicalMatches
                            .map(
                              (final TechnicalMatchData e) =>
                                  e.autoAmpMissed + e.teleAmpMissed,
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
                                  e.autoAmp * PointGiver.autoAmp.points +
                                  e.teleAmp * PointGiver.teleAmp.points +
                                  e.autoSpeaker *
                                      PointGiver.autoSpeaker.points +
                                  e.teleSpeaker * PointGiver.teleSpeaker.points,
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
                            .map((final TechnicalMatchData e) => e.trapAmount)
                            .toList(),
                        data.technicalMatches
                            .map((final TechnicalMatchData e) => e.trapsMissed)
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
        gameNumbers: data.technicalMatches
            .map(
              (final TechnicalMatchData e) => MatchIdentifier(
                number: e.matchNumber,
                type: IdProvider.of(context).matchType.idToName[e.matchTypeId]!,
                isRematch: e.isRematch,
              ),
            )
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
        gameNumbers: data.technicalMatches
            .map(
              (final TechnicalMatchData e) => MatchIdentifier(
                number: e.matchNumber,
                type: IdProvider.of(context).matchType.idToName[e.matchTypeId]!,
                isRematch: e.isRematch,
              ),
            )
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

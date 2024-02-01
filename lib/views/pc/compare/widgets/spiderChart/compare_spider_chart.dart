import "dart:collection";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/fetch_functions/climb_enum.dart";
import "package:scouting_frontend/views/common/fetch_functions/parse_match_functions.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
import "package:scouting_frontend/views/pc/compare/widgets/spiderChart/radar_chart.dart";

class CompareSpiderChart extends StatelessWidget {
  const CompareSpiderChart(this.data);
  final SplayTreeSet<TeamData> data;

  Iterable<TeamData> get emptyTeams => data.where(
        (final TeamData team) => team.technicalMatches.length < 2,
      );

  @override
  Widget build(final BuildContext context) => emptyTeams.isNotEmpty
      ? Container()
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Builder(
            builder: (final BuildContext context) => SpiderChart(
              colors: data
                  .map(
                    (final TeamData team) => team.lightTeam.color,
                  )
                  .toList(),
              numberOfFeatures: 5,
              data: data
                  .map(
                    (final TeamData team) => <double>[
                      100 *
                          PointGiver.autoAmp
                              .calcPoints(team.aggregateData.avgAutoAmp) /
                          (PointGiver.autoAmp.calcPoints(
                                team.aggregateData.avgAutoAmp,
                              ) +
                              PointGiver.autoSpeaker.calcPoints(
                                team.aggregateData.avgAutoSpeaker,
                              )),
                      100 *
                          PointGiver.autoSpeaker.calcPoints(
                            team.aggregateData.avgAutoSpeaker,
                          ) /
                          (PointGiver.autoAmp.calcPoints(
                                team.aggregateData.avgAutoAmp,
                              ) +
                              PointGiver.autoSpeaker.calcPoints(
                                team.aggregateData.avgAutoSpeaker,
                              )),
                      100 *
                          PointGiver.teleAmp
                              .calcPoints(team.aggregateData.avgTeleAmp) /
                          (PointGiver.teleAmp.calcPoints(
                                team.aggregateData.avgTeleAmp,
                              ) +
                              PointGiver.teleSpeaker.calcPoints(
                                team.aggregateData.avgTeleSpeaker,
                              )),
                      100 *
                          PointGiver.teleSpeaker.calcPoints(
                            team.aggregateData.avgTeleSpeaker,
                          ) /
                          (PointGiver.teleAmp.calcPoints(
                                team.aggregateData.avgTeleAmp,
                              ) +
                              PointGiver.teleSpeaker.calcPoints(
                                team.aggregateData.avgTeleSpeaker,
                              )),
                      100 *
                          team.technicalMatches
                              .where(
                                (final TechnicalMatchData element) =>
                                    element.climb == Climb.climbed,
                              )
                              .length /
                          team.technicalMatches.length,
                    ]
                        .map<int>(
                          (final double e) =>
                              e.isNaN || e.isInfinite ? 0 : e.toInt(),
                        )
                        .toList(),
                  )
                  .toList(),
              ticks: const <int>[0, 25, 50, 75, 100],
              features: const <String>[
                "Auto Amp",
                "Auto Speaker",
                "Tele Amp",
                "Tele Speaker",
                "Climb Percentage",
              ],
            ),
          ),
        );
}

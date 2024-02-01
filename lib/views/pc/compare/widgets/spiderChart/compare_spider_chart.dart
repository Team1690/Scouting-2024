import "dart:collection";
import "dart:math";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/fetch_functions/parse_match_functions.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
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
            builder: (final BuildContext context) {
              final double teleGamepiecePointRatio = 100 /
                  data
                      .map(
                        (final TeamData team) =>
                            team.aggregateData.avgTeleAmp +
                            team.aggregateData.avgTeleSpeaker,
                      )
                      .reduce(max);
              final double autoGamepiecePointRatio = 100 /
                  data
                      .map(
                        (final TeamData team) =>
                            team.aggregateData.avgAutoSpeaker +
                            team.aggregateData.avgAutoAmp,
                      )
                      .reduce(max);
              return SpiderChart(
                colors: data
                    .map(
                      (final TeamData team) => team.lightTeam.color,
                    )
                    .toList(),
                //TODO: calc appropiate ratios and split speaker from amp
                numberOfFeatures: 2,
                data: data
                    .map(
                      (final TeamData team) => <double>[
                        ((PointGiver.autoAmp
                                    .calcPoints(team.aggregateData.avgAutoAmp) +
                                PointGiver.autoSpeaker.calcPoints(
                                  team.aggregateData.avgAutoSpeaker,
                                )) *
                            autoGamepiecePointRatio),
                        ((PointGiver.teleAmp
                                    .calcPoints(team.aggregateData.avgTeleAmp) +
                                PointGiver.teleSpeaker.calcPoints(
                                  team.aggregateData.avgTeleSpeaker,
                                )) *
                            teleGamepiecePointRatio),
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
                ],
              );
            },
          ),
        );
}

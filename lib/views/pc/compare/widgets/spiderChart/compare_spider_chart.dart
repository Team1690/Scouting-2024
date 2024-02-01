import "dart:collection";
import "dart:math";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/pc/compare/models/compare_team_data.dart";
import "package:scouting_frontend/views/pc/compare/widgets/spiderChart/radar_chart.dart";

class CompareSpiderChart extends StatelessWidget {
  const CompareSpiderChart(this.data);
  final SplayTreeSet<CompareTeamData> data;

  Iterable<CompareTeamData> get emptyTeams => data.where(
        (final CompareTeamData team) => team.gamepieces.points.length < 2,
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
                        (final CompareTeamData team) =>
                            team.avgTeleGamepiecesPoints,
                      )
                      .reduce(max);
              final double autoGamepiecePointRatio = 100 /
                  data
                      .map(
                        (final CompareTeamData team) =>
                            team.avgAutoGamepiecePoints,
                      )
                      .reduce(max);
              return SpiderChart(
                colors: data
                    .map(
                      (final CompareTeamData team) => team.team.color,
                    )
                    .toList(),
                numberOfFeatures: 4,
                data: data
                    .map(
                      (final CompareTeamData team) => <double>[
                        (team.avgTeleGamepiecesPoints *
                            teleGamepiecePointRatio),
                        (team.avgAutoGamepiecePoints * autoGamepiecePointRatio),
                        (team.avgTeleGamepiecesPoints *
                                teleGamepiecePointRatio) /
                            2,
                        (team.avgAutoGamepiecePoints *
                                autoGamepiecePointRatio) /
                            2,
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
                  "TODO",
                  "TODO",
                  "TODO",
                  "TODO",
                ],
              );
            },
          ),
        );
}

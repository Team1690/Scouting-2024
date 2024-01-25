import "dart:collection";
import "dart:math";

import "package:flutter/material.dart";
import "package:scouting_frontend/views/pc/compare/models/compare_classes.dart";
import "package:scouting_frontend/views/pc/compare/widgets/spiderChart/radar_chart.dart";

class CompareSpiderChart extends StatelessWidget {
  const CompareSpiderChart(this.data);
  final SplayTreeSet<CompareTeam> data;

  Iterable<CompareTeam> get emptyTeams => data.where(
        (final CompareTeam team) => team.gamepieces.points.length < 2,
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
                        (final CompareTeam team) =>
                            team.avgTeleGamepiecesPoints,
                      )
                      .reduce(max);
              final double autoGamepiecePointRatio = 100 /
                  data
                      .map(
                        (final CompareTeam team) => team.avgAutoGamepiecePoints,
                      )
                      .reduce(max);
              return SpiderChart(
                colors: data
                    .map(
                      (final CompareTeam team) => team.team.color,
                    )
                    .toList(),
                numberOfFeatures: 2,
                data: data
                    .map(
                      (final CompareTeam team) => <int>[
                        (team.avgTeleGamepiecesPoints * teleGamepiecePointRatio)
                            .toInt(),
                        (team.avgAutoGamepiecePoints * autoGamepiecePointRatio)
                            .toInt(),
                      ],
                    )
                    .toList(),
                ticks: const <int>[0, 25, 50, 75, 100],
                features: const <String>[
                  "Tele Gamepieces",
                  "Auto Gamepieces",
                ],
              );
            },
          ),
        );
}

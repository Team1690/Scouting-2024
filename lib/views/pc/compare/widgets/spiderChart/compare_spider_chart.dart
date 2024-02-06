import "dart:collection";
import "dart:math";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/point_giver_enum.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
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
              numberOfFeatures: 6,
              data: data.map((final TeamData team) {
                //TODO: fetch and getters
                final double maxAutoPoints = data
                    .map(
                      (final TeamData element) => element.technicalMatches
                          .map(
                            (final TechnicalMatchData match) =>
                                match.data.autoPoints,
                          )
                          .fold(0, max),
                    )
                    .fold(0, max)
                    .toDouble();
                final double maxTeleAmp = data
                    .map(
                      (final TeamData element) =>
                          element.aggregateData.maxData.teleAmp,
                    )
                    .fold(0, max)
                    .toDouble();
                final double maxTeleSpeaker = data
                    .map(
                      (final TeamData element) =>
                          element.aggregateData.maxData.teleSpeaker,
                    )
                    .fold(0, max)
                    .toDouble();
                const double maxTrapAmount = 2;
                return <double>[
                  100 * (team.aggregateData.avgData.autoPoints) / maxAutoPoints,
                  100 *
                      team.aggregateData.avgData.teleAmpPoints /
                      PointGiver.teleAmp.calcPoints(maxTeleAmp),
                  100 *
                      team.aggregateData.avgData.teleSpeakerPoints /
                      PointGiver.teleSpeaker.calcPoints(maxTeleSpeaker),
                  team.climbPercentage,
                  team.aim,
                  //TODO: trap percentage if it is suddenly important
                  100 * team.aggregateData.avgData.trapAmount / maxTrapAmount,
                ]
                    .map<int>(
                      (final double e) =>
                          e.isNaN || e.isInfinite ? 0 : e.toInt(),
                    )
                    .toList();
              }).toList(),
              ticks: const <int>[0, 25, 50, 75, 100],
              features: const <String>[
                "Auto Gamepieces",
                "Tele Amp",
                "Tele Speaker",
                "Climb Percentage",
                "Aim",
                "Average Trap",
              ],
            ),
          ),
        );
}

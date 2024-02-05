import "dart:collection";
import "dart:math";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/parse_match_functions.dart";
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
              numberOfFeatures: 5,
              data: data.map((final TeamData team) {
                //TODO: fetch and getters
                final double maxAutoPoints = data
                    .map(
                      (final TeamData element) => element.technicalMatches
                          .map((final TechnicalMatchData e) => e.autoPoints)
                          .fold(0, max),
                    )
                    .fold(0, max)
                    .toDouble();
                final double maxTeleAmp = data
                    .map(
                      (final TeamData element) =>
                          element.aggregateData.maxTeleAmp,
                    )
                    .fold(0, max)
                    .toDouble();
                final double maxTeleSpeaker = data
                    .map(
                      (final TeamData element) =>
                          element.aggregateData.maxTeleSpeaker,
                    )
                    .fold(0, max)
                    .toDouble();
                const double maxTrapAmount = 2;
                return <double>[
                  100 *
                      (team.technicalMatches
                              .map((final TechnicalMatchData e) => e.autoPoints)
                              .sum /
                          team.technicalMatches.length) /
                      maxAutoPoints,
                  100 *
                      PointGiver.teleAmp
                          .calcPoints(team.aggregateData.avgTeleAmp) /
                      PointGiver.teleAmp.calcPoints(maxTeleAmp),
                  100 *
                      PointGiver.teleSpeaker.calcPoints(
                        team.aggregateData.avgTeleSpeaker,
                      ) /
                      PointGiver.teleSpeaker.calcPoints(maxTeleSpeaker),
                  100 *
                      (team.technicalMatches
                              .where(
                                (final TechnicalMatchData element) =>
                                    element.climb != Climb.noAttempt,
                              )
                              .isEmpty
                          ? 0
                          : team.technicalMatches
                                  .where(
                                    (final TechnicalMatchData element) =>
                                        element.climb == Climb.climbed ||
                                        element.climb == Climb.buddyClimbed,
                                  )
                                  .length /
                              team.technicalMatches
                                  .where(
                                    (final TechnicalMatchData element) =>
                                        element.climb != Climb.noAttempt,
                                  )
                                  .length),
                  //TODO: trap percentage if it is suddenly important
                  100 * team.aggregateData.avgTrapAmount / maxTrapAmount,
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
                "Average Trap",
              ],
            ),
          ),
        );
}

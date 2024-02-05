import "dart:collection";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/card.dart";
import 'package:scouting_frontend/models/team_data/team_data.dart';
import 'package:scouting_frontend/models/team_data/technical_match_data.dart';
import "package:scouting_frontend/views/common/no_team_selected.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/compare/widgets/lineChart/compare_titled_line_chart.dart";
import "package:scouting_frontend/views/pc/compare/widgets/lineChart/compare_line_chart.dart";

class CompareGamechartCard extends StatelessWidget {
  const CompareGamechartCard(this.data, this.teams);
  final SplayTreeSet<TeamData> data;
  final SplayTreeSet<LightTeam> teams;
  @override
  Widget build(final BuildContext context) {
    final Iterable<TeamData> emptyTeams = data.where(
      (final TeamData element) => element.technicalMatches.length < 2,
    );
    final List<Color> colors = data
        .map(
          (final TeamData teamData) => teamData.lightTeam.color,
        )
        .toList();
    return DashboardCard(
      title: "Gamechart",
      body: teams.isEmpty
          ? NoTeamSelected()
          : emptyTeams.isNotEmpty
              ? Text(
                  "teams: ${emptyTeams.map((final TeamData compareTeam) => compareTeam.lightTeam.number).toString()} have insufficient data, please remove them",
                )
              : Builder(
                  builder: (
                    final BuildContext context,
                  ) =>
                      CarouselWithIndicator(
                    direction: isPC(context) ? Axis.horizontal : Axis.vertical,
                    widgets: <Widget>[
                      CompareLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData teamData) =>
                                  teamData.technicalMatches
                                      .map(
                                        (final TechnicalMatchData match) =>
                                            match.gamepieces,
                                      )
                                      .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Total Gamepieces",
                      ),
                      CompareLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData element) =>
                                  element.technicalMatches
                                      .map(
                                        (final TechnicalMatchData match) =>
                                            match.gamePiecesPoints,
                                      )
                                      .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Gamepiece Points",
                      ),
                      CompareLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData element) =>
                                  element.technicalMatches
                                      .map(
                                        (final TechnicalMatchData match) =>
                                            match.totalMissed,
                                      )
                                      .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Total Missed",
                      ),
                      CompareLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData element) =>
                                  element.technicalMatches
                                      .map(
                                        (final TechnicalMatchData match) =>
                                            match.autoGamepieces,
                                      )
                                      .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Auto Gamepieces",
                      ),
                      CompareLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData element) =>
                                  element.technicalMatches
                                      .map(
                                        (final TechnicalMatchData match) =>
                                            match.teleGamepieces,
                                      )
                                      .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Teleop Gamepieces",
                      ),
                      CompareLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData element) =>
                                  element.technicalMatches
                                      .map(
                                        (final TechnicalMatchData match) =>
                                            match.ampGamepieces,
                                      )
                                      .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Total Amps",
                      ),
                      CompareLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData element) =>
                                  element.technicalMatches
                                      .map(
                                        (final TechnicalMatchData match) =>
                                            match.speakerGamepieces,
                                      )
                                      .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Total Speakers",
                      ),
                      CompareLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData element) =>
                                  element.technicalMatches
                                      .map(
                                        (final TechnicalMatchData match) =>
                                            match.trapAmount,
                                      )
                                      .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Total Traps",
                      ),
                      CompareClimbLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData element) =>
                                  element.technicalMatches
                                      .map(
                                        (final TechnicalMatchData match) =>
                                            match.climb.chartHeight.toInt(),
                                      )
                                      .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Climbed",
                      ),
                    ],
                  ),
                ),
    );
  }
}

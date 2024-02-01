import "dart:collection";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/no_team_selected.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/compare/models/compare_team_data.dart";
import "package:scouting_frontend/views/pc/compare/widgets/lineChart/compare_titled_line_chart.dart";
import "package:scouting_frontend/views/pc/compare/widgets/lineChart/compare_line_chart.dart";

class CompareGamechartCard extends StatelessWidget {
  const CompareGamechartCard(this.data, this.teams);
  final SplayTreeSet<CompareTeamData> data;
  final SplayTreeSet<LightTeam> teams;
  @override
  Widget build(final BuildContext context) {
    final Iterable<CompareTeamData> emptyTeams = data.where(
      (final CompareTeamData element) => element.gamepieces.points.length < 2,
    );
    final List<Color> colors = data
        .map(
          (final CompareTeamData element) => element.team.color,
        )
        .toList();
    return DashboardCard(
      title: "Gamechart",
      body: teams.isEmpty
          ? NoTeamSelected()
          : emptyTeams.isNotEmpty
              ? Text(
                  "teams: ${emptyTeams.map((final CompareTeamData compareTeam) => compareTeam.team.number).toString()} have insufficient data, please remove them",
                )
              : Builder(
                  builder: (
                    final BuildContext context,
                  ) =>
                      CarouselWithIndicator(
                    direction: isPC(context) ? Axis.horizontal : Axis.vertical,
                    widgets: <Widget>[
                      CompareLineChart(
                        data
                            .map(
                              (final CompareTeamData element) =>
                                  element.gamepieces,
                            )
                            .toList(),
                        colors,
                        "Total Gamepieces",
                      ),
                      CompareLineChart(
                        data
                            .map(
                              (final CompareTeamData element) =>
                                  element.gamepiecePoints,
                            )
                            .toList(),
                        colors,
                        "Gamepiece Points",
                      ),
                      CompareLineChart(
                        data
                            .map(
                              (final CompareTeamData element) =>
                                  element.totalMissed,
                            )
                            .toList(),
                        colors,
                        "Total Missed",
                      ),
                      CompareLineChart(
                        data
                            .map(
                              (final CompareTeamData element) =>
                                  element.autoGamepieces,
                            )
                            .toList(),
                        colors,
                        "Auto Gamepieces",
                      ),
                      CompareLineChart(
                        data
                            .map(
                              (final CompareTeamData element) =>
                                  element.teleGamepieces,
                            )
                            .toList(),
                        colors,
                        "Teleop Gamepieces",
                      ),
                      CompareLineChart(
                        data
                            .map(
                              (final CompareTeamData element) =>
                                  element.totalAmps,
                            )
                            .toList(),
                        colors,
                        "Total Amps",
                      ),
                      CompareLineChart(
                        data
                            .map(
                              (final CompareTeamData element) =>
                                  element.totalSpeakers,
                            )
                            .toList(),
                        colors,
                        "Total Speakers",
                      ),
                      CompareClimbLineChart(
                        data
                            .map(
                              (final CompareTeamData element) =>
                                  element.climbed,
                            )
                            .toList(),
                        colors,
                        "Climbed",
                      ),
                    ],
                  ),
                ),
    );
  }
}

import "dart:collection";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/fetch_functions/climb_enum.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
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
                                            match.gamepiecesPoints,
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
                                            match.teleAmpMissed +
                                            match.autoAmpMissed +
                                            match.teleSpeakerMissed +
                                            match.autoSpeakerMissed,
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
                                            match.autoAmp + match.teleAmp,
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
                              (final TeamData element) => element
                                  .technicalMatches
                                  .map(
                                    (final TechnicalMatchData match) =>
                                        match.autoSpeaker + match.teleSpeaker,
                                  )
                                  .toList(),
                            )
                            .toList(),
                        colors: colors,
                        title: "Total Speakers",
                      ),
                      CompareClimbLineChart(
                        teamDatas: data.toList(),
                        data: data
                            .map(
                              (final TeamData element) => element
                                  .technicalMatches
                                  .map(
                                    (final TechnicalMatchData match) =>
                                        match.climb == Climb.failed ||
                                                match.climb == Climb.noAttempt
                                            ? 0
                                            : 1,
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

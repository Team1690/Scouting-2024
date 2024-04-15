import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/gamepiece_line_chart.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/points_linechart.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/titled_line_chart.dart";

class Gamechart extends StatelessWidget {
  const Gamechart({super.key, required this.data, this.direction});
  final TeamData data;
  final Axis? direction;

  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "Game Chart",
        body: data.technicalMatches.length < 2
            ? const Text("Not enough data for line chart")
            : CarouselWithIndicator(
                direction: direction ?? Axis.horizontal,
                widgets: <Widget>[
                  GamepiecesLineChart(
                    title: "Gamepieces",
                    matches: data.matches,
                    data: (final MatchData p0) =>
                        p0.technicalMatchData!.data.gamepieces,
                    missedData: (final MatchData p0) =>
                        p0.technicalMatchData!.data.totalMissed,
                    deliveryData: (final MatchData p0) =>
                        p0.technicalMatchData!.data.delivery,
                  ),
                  GamepiecesLineChart(
                    title: "Auto Gamepieces",
                    matches: data.matches,
                    data: (final MatchData p0) =>
                        p0.technicalMatchData!.data.autoGamepieces,
                    missedData: (final MatchData p0) =>
                        p0.technicalMatchData!.data.missedAuto,
                  ),
                  GamepiecesLineChart(
                    title: "Speaker Gamepieces",
                    matches: data.matches,
                    data: (final MatchData p0) =>
                        p0.technicalMatchData!.data.speakerGamepieces,
                    missedData: (final MatchData p0) =>
                        p0.technicalMatchData!.data.missedSpeaker,
                  ),
                  GamepiecesLineChart(
                    title: "Amp Gamepieces",
                    matches: data.matches,
                    data: (final MatchData p0) =>
                        p0.technicalMatchData!.data.ampGamepieces,
                    missedData: (final MatchData p0) =>
                        p0.technicalMatchData!.data.missedAmp,
                  ),
                  PointsLineChart(
                    title: "Gamepiece Points",
                    matches: data.matches,
                    data: (final MatchData p0) =>
                        p0.technicalMatchData!.data.gamePiecesPoints,
                  ),
                  PointsLineChart(
                    title: "Gamepieces brought to wing",
                    data: (final MatchData p0) =>
                        p0.technicalMatchData!.data.delivery,
                    matches: data.matches,
                    color: Colors.yellow,
                    sideTitlesInterval: 2,
                  ),
                  GamepiecesLineChart(
                    title: "Traps",
                    matches: data.matches,
                    data: (final MatchData p0) =>
                        p0.technicalMatchData!.data.trapAmount,
                    missedData: (final MatchData p0) =>
                        p0.technicalMatchData!.data.trapsMissed,
                  ),
                  TitledLineChart(
                    title: "Climbed",
                    matches: data.matches,
                    data: (final MatchData p0) =>
                        p0.technicalMatchData!.climb.chartHeight.toInt(),
                    heightToTitles: <int, String>{
                      for (final Climb climb in Climb.values)
                        climb.chartHeight.toInt(): climb.title,
                    },
                  ),
                ],
              ),
      );
}

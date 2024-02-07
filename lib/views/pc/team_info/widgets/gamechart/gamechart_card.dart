import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/enums/point_giver_enum.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/gamepiece_line_chart.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/points_linechart.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/titled_line_chart.dart";
import "package:scouting_frontend/models/enums/defense_amount_enum.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";

class Gamechart extends StatelessWidget {
  const Gamechart(this.data);
  final TeamData data;
  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "Game Chart",
        body: data.technicalMatches.length < 2
            ? const Text("Not enough data for line chart")
            : CarouselWithIndicator(
                widgets: <Widget>[
                  GamepiecesLineChart(
                    title: "Gamepieces",
                    matches: data.matches,
                    data: (p0) => p0.technicalMatchData!.data.gamepieces,
                  ),
                  GamepiecesLineChart(
                    title: "Auto Gamepieces",
                    matches: data.matches,
                    data: (p0) => p0.technicalMatchData!.data.autoGamepieces,
                  ),
                  GamepiecesLineChart(
                    title: "Speaker Gamepieces",
                    matches: data.matches,
                    data: (p0) => p0.technicalMatchData!.data.speakerGamepieces,
                  ),
                  GamepiecesLineChart(
                    title: "Amp Gamepieces",
                    matches: data.matches,
                    data: (p0) => p0.technicalMatchData!.data.ampGamepieces,
                  ),
                  PointsLineChart(
                    title: "Gamepiece Points",
                    matches: data.matches,
                    data: (p0) => p0.technicalMatchData!.data.gamePiecesPoints,
                  ),
                  GamepiecesLineChart(
                    title: "Traps",
                    matches: data.matches,
                    data: (p0) => p0.technicalMatchData!.data.trapAmount,
                  ),
                  TitledLineChart(
                    title: "Climbed",
                    matches: data.matches,
                    data: (p0) =>
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

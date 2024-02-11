import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";

class CoachTeamInfoLineCharts extends StatelessWidget {
  CoachTeamInfoLineCharts(this.data);
  final TeamData data;
  @override
  Widget build(final BuildContext context) => CarouselWithIndicator(
        direction: Axis.vertical,
        enableInfininteScroll: true,
        //TODO add linecharts
        widgets: const <Widget>[
          Text("Line Charts here"),
        ],
      );
}

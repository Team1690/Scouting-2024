import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/mobile/screens/robot_image.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_match_card.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_summary_card.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";

class Specific extends StatefulWidget {
  @override
  State<Specific> createState() => _SpecificState();
}

class _SpecificState extends State<Specific> {
  final FocusNode node = FocusNode();
  LightTeam? team;

  void setTeam(final LightTeam team) {
    this.team = team;
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: node.unfocus,
        child: Scaffold(
          drawer: SideNavBar(),
          appBar: AppBar(
            actions: <Widget>[RobotImageButton(teamId: () => team?.id)],
            centerTitle: true,
            title: const Text("Specific"),
          ),
          body: CarouselWithIndicator(
            widgets: <Widget>[
              SpecificMatchCard(onTeamSelected: setTeam),
              SpecificSummaryCard(onTeamSelected: setTeam),
            ],
          ),
        ),
      );
}

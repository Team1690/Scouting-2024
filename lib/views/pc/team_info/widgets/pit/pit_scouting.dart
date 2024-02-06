import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/pit_scouting_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/robot_image_card.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_data/pit_data/pit_data.dart";

class PitScouting extends StatelessWidget {
  const PitScouting(this.p0);

  final TeamData? p0;

  @override
  Widget build(final BuildContext context) =>
      p0?.pitData.mapNullable(
        (final PitData pitData) => Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: RobotImageCard(pitData.url),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Expanded(
              flex: 6,
              child: PitScoutingCard(pitData),
            ),
          ],
        ),
      ) ??
      Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: DashboardCard(
              title: "Robot Image",
              body: Container(),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Expanded(
            flex: 6,
            child: DashboardCard(
              title: "Pit Scouting",
              body: Container(),
            ),
          ),
        ],
      );
}

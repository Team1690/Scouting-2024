import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/pit_scouting_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/robot_image_card.dart";
import "package:scouting_frontend/models/data/pit_data/pit_data.dart";

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
      const Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: DashboardCard(
              title: "",
              body: Center(
                child: Text("No Pit Data :("),
              ),
            ),
          ),
        ],
      );
}

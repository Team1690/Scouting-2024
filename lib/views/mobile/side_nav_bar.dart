import "package:flutter/material.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/mobile/screens/coach_team_info/coach_team_info.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_view.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/fault_view.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_view.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_view.dart";
import "package:scouting_frontend/views/pc/auto_gamepieces/auto_gamepieces_view.dart";
import "package:scouting_frontend/views/pc/compare/compare_screen.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_screen.dart";
import "package:scouting_frontend/views/common/navbar_tile.dart";

import "../../models/providers/team_provider.dart";

class SideNavBar extends StatelessWidget {
  final TextEditingController teamSelectionController = TextEditingController();
  @override
  Widget build(final BuildContext context) => Drawer(
        child: ListView(
          primary: false,
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF2A2D3E),
              ),
              child: Text(
                "Options",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TeamSelectionFuture(
                teams: TeamProvider.of(context).teams,
                onChange: (final LightTeam team) {
                  teamSelectionController.clear();
                  Navigator.of(context).push(
                    MaterialPageRoute<CoachTeamInfo>(
                      builder: (final BuildContext contxt) =>
                          CoachTeamInfo(team),
                    ),
                  );
                },
                controller: teamSelectionController,
              ),
            ),
            const NavbarTile(
              icon: Icons.precision_manufacturing_sharp,
              title: "Technical",
              widget: UserInput.new,
            ),
            const NavbarTile(
              icon: Icons.person_search_sharp,
              title: "Specific",
              widget: Specific.new,
            ),
            const NavbarTile(
              icon: Icons.build,
              title: "Pit",
              widget: PitView.new,
            ),
            const NavbarTile(
              icon: Icons.construction,
              title: "Faults",
              widget: FaultView.new,
            ),
            const NavbarTile(
              icon: Icons.route,
              title: "Auto",
              widget: AutoGamepiecesScreen.new,
            ),
            const NavbarTile(
              icon: Icons.feed_outlined,
              title: "Coach",
              widget: CoachView.new,
            ),
            const NavbarTile(
              icon: Icons.list,
              title: "Picklist",
              widget: PickListScreen.new,
            ),
            const NavbarTile(
              icon: Icons.compare_arrows_rounded,
              title: "Compare",
              widget: CompareScreen.new,
            ),
          ],
        ),
      );
}

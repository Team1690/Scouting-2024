import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/navbar_tile.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/blue_alliance_compare_screen.dart";
import "package:scouting_frontend/views/pc/matches/matches_screen.dart";
import "package:scouting_frontend/views/pc/scatter/scatters_screen.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_screen.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shifts_screen.dart";
import "package:scouting_frontend/views/pc/status/status.dart";
import "package:scouting_frontend/views/pc/team_info/team_info_screen.dart";
import "package:scouting_frontend/views/pc/compare/compare_screen.dart";
import "package:scouting_frontend/views/pc/team_list/screen.dart";

class NavigationTab extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                "lib/assets/logo.png",
              ),
              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
            ),
            const NavbarTile(
              icon: Icons.info_outline,
              title: "Team Info",
              widget: TeamInfoScreen.new,
            ),
            const NavbarTile(
              icon: Icons.list,
              title: "Pick List",
              widget: PickListScreen.new,
            ),
            const NavbarTile(
              icon: Icons.compare_arrows,
              title: "Compare",
              widget: CompareScreen.new,
            ),
            const NavbarTile(
              icon: Icons.bar_chart_rounded,
              title: "Scatter",
              widget: ScatterScreen.new,
            ),
            const NavbarTile(
              icon: Icons.mobile_friendly,
              title: "Status",
              widget: Status.new,
            ),
            const NavbarTile(
              icon: Icons.groups,
              title: "Scouting Shifts",
              widget: ScoutingShiftsScreen.new,
            ),
            const NavbarTile(
              icon: Icons.list_alt,
              title: "Team List",
              widget: TeamList.new,
            ),
            const NavbarTile(
              icon: Icons.add_circle_outline,
              title: "Matches",
              widget: MatchesScreen.new,
            ),
            const NavbarTile(
              icon: Icons.query_stats,
              title: "Blue Alliance Compare",
              widget: BlueAllianceCompareScreen.new,
            ),
          ],
        ),
      );
}

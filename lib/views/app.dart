import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/matches_provider.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view.dart";
import "package:scouting_frontend/views/pc/team_info/team_info_screen.dart";

class App extends StatelessWidget {
  App({
    required this.teams,
    required this.climbIds,
    required this.driveMotorIds,
    required this.drivetrainIds,
    required this.matchTypeIds,
    required this.robotFieldStatusIds,
    required this.faultStatus,
    required this.matches,
    required this.defense,
    required this.startingPosition,
    required this.driveWheelIds,
  });
  final List<ScheduleMatch> matches;
  final Map<String, int> robotFieldStatusIds;
  final List<LightTeam> teams;
  final Map<String, int> climbIds;
  final Map<String, int> drivetrainIds;
  final Map<String, int> driveMotorIds;
  final Map<String, int> driveWheelIds;
  final Map<String, int> matchTypeIds;
  final Map<String, int> faultStatus;
  final Map<String, int> defense;
  final Map<String, int> startingPosition;
  @override
  Widget build(final BuildContext context) => TeamProvider(
        teams: teams,
        child: MatchesProvider(
          matches: matches,
          child: IdProvider(
            startingPosition: startingPosition,
            matchTypeIds: matchTypeIds,
            climbIds: climbIds,
            drivemotorIds: driveMotorIds,
            drivetrainIds: drivetrainIds,
            robotFieldStatusIds: robotFieldStatusIds,
            faultStatus: faultStatus,
            defense: defense,
            driveWheelIds: driveWheelIds,
            child: MaterialApp(
              title: "Orbit Scouting",
              home: isPC(context) ? TeamInfoScreen() : const UserInput(),
              theme: darkModeTheme,
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      );
}

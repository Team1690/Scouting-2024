import "package:scouting_frontend/models/data/starting_position_enum.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/enums/fault_status_enum.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
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
    required this.startingPosition,
  });
  final List<ScheduleMatch> matches;
  final Map<RobotFieldStatus, int> robotFieldStatusIds;
  final List<LightTeam> teams;
  final Map<Climb, int> climbIds;
  final Map<DriveTrain, int> drivetrainIds;
  final Map<DriveMotor, int> driveMotorIds;
  final Map<MatchType, int> matchTypeIds;
  final Map<FaultStatus, int> faultStatus;
  final Map<StartingPosition, int> startingPosition;
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

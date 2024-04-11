import "dart:io";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/autonomous_options_enum.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/enums/fault_status_enum.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
import "package:scouting_frontend/models/enums/shooting_range_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/fetch_matches.dart";
import "package:scouting_frontend/net/fetch_scouters.dart";
import "package:scouting_frontend/net/fetch_shifts.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/app.dart";
import "package:scouting_frontend/firebase_options.dart";
import "package:scouting_frontend/models/id_helpers.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb || Platform.isAndroid || Platform.isMacOS || Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  final Map<String, Map<String, int>> enums = await fetchEnums(<String>[
    "climb", //TODO change the names of these tables if needed
    "drivetrain",
    "drivemotor",
    "robot_field_status",
    "fault_status",
    "shooting_range",
    "autonomous_options",
  ], <String>[
    "match_type",
  ]);

  final Map<Climb, int> climbs =
      nameToIdToEnumToId(Climb.values, enums["climb"]!);
  final Map<DriveTrain, int> driveTrains =
      nameToIdToEnumToId(DriveTrain.values, enums["drivetrain"]!);
  final Map<DriveMotor, int> driveMotors =
      nameToIdToEnumToId(DriveMotor.values, enums["drivemotor"]!);
  final Map<MatchType, int> matchTypes =
      nameToIdToEnumToId(MatchType.values, enums["match_type"]!);
  final Map<RobotFieldStatus, int> robotFieldStatuses =
      nameToIdToEnumToId(RobotFieldStatus.values, enums["robot_field_status"]!);
  final Map<FaultStatus, int> faultStatus =
      nameToIdToEnumToId(FaultStatus.values, enums["fault_status"]!);
  final Map<ShootingRange, int> shootingRange =
      nameToIdToEnumToId(ShootingRange.values, enums["shooting_range"]!);
  final Map<AutonomousOptions, int> autoOptions = nameToIdToEnumToId(
      AutonomousOptions.values, enums["autonomous_options"]!);
  final List<ScheduleMatch> matches = await fetchMatches(
    IdTable<MatchType>(
      matchTypes,
    ), /* TODO: dont create new IdTable use one that is created afterwards */
  );
  final List<ScoutingShift> shifts =
      await fetchShifts(IdTable<MatchType>(matchTypes));
  final List<String> scouters = await fetchScouters();
  final List<LightTeam> teams = await fetchTeams();

  runApp(
    App(
      matches: matches,
      faultStatus: faultStatus,
      matchTypeIds: matchTypes,
      teams: teams,
      drivetrainIds: driveTrains,
      climbIds: climbs,
      driveMotorIds: driveMotors,
      robotFieldStatusIds: robotFieldStatuses,
      shootingRange: shootingRange,
      shifts: shifts,
      scouters: scouters,
      autoOptions: autoOptions,
    ),
  );
}

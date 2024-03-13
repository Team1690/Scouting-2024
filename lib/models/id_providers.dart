import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/starting_position_enum.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/enums/fault_status_enum.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
import "package:scouting_frontend/models/enums/shooting_range_enum.dart";
import "package:scouting_frontend/models/team_model.dart";

class IdTable<T> {
  IdTable(final Map<T, int> enumToId)
      : this._inner(
          enumToId: Map<T, int>.unmodifiable(enumToId),
          idToEnum: Map<int, T>.unmodifiable(
            <int, T>{
              for (final MapEntry<T, int> e in enumToId.entries) e.value: e.key,
            },
          ),
        );

  const IdTable._inner({required this.idToEnum, required this.enumToId});
  final Map<T, int> enumToId;
  final Map<int, T> idToEnum;
}

abstract class IdEnum {
  String get title;
}

Map<T, int> nameToIdToEnumToId<T extends IdEnum>(
  final List<T> values,
  final Map<String, int> nameToId,
) =>
    <T, int>{
      for (final T e in values)
        e: nameToId[e.title] ?? (throw Exception("Enum: ${e.title} not found")),
    };

class IdProvider extends InheritedWidget {
  IdProvider({
    required final Widget child,
    required final Map<Climb, int> climbIds,
    required final Map<DriveTrain, int> drivetrainIds,
    required final Map<DriveMotor, int> drivemotorIds,
    required final Map<MatchType, int> matchTypeIds,
    required final Map<RobotFieldStatus, int> robotFieldStatusIds,
    required final Map<FaultStatus, int> faultStatus,
    required final Map<StartingPosition, int> startingPosition,
    required final Map<ShootingRange, int> shootingRange,
  }) : this._inner(
          child: child,
          climb: IdTable<Climb>(climbIds),
          driveTrain: IdTable<DriveTrain>(drivetrainIds),
          drivemotor: IdTable<DriveMotor>(drivemotorIds),
          matchType: IdTable<MatchType>(matchTypeIds),
          robotFieldStatus: IdTable<RobotFieldStatus>(robotFieldStatusIds),
          faultStatus: IdTable<FaultStatus>(faultStatus),
          startingPosition: IdTable<StartingPosition>(startingPosition),
          shootingRange: IdTable<ShootingRange>(shootingRange),
        );

  IdProvider._inner({
    required super.child,
    required this.climb,
    required this.driveTrain,
    required this.drivemotor,
    required this.matchType,
    required this.robotFieldStatus,
    required this.faultStatus,
    required this.startingPosition,
    required this.shootingRange,
  });
  final IdTable<RobotFieldStatus> robotFieldStatus;
  final IdTable<MatchType> matchType;
  final IdTable<Climb> climb;
  final IdTable<DriveTrain> driveTrain;
  final IdTable<DriveMotor> drivemotor;
  final IdTable<FaultStatus> faultStatus;
  final IdTable<StartingPosition> startingPosition;
  final IdTable<ShootingRange> shootingRange;

  @override
  bool updateShouldNotify(final IdProvider oldWidget) =>
      robotFieldStatus != oldWidget.robotFieldStatus ||
      climb != oldWidget.climb ||
      matchType != oldWidget.matchType ||
      driveTrain != oldWidget.driveTrain ||
      drivemotor != oldWidget.drivemotor ||
      faultStatus != oldWidget.faultStatus ||
      startingPosition != oldWidget.startingPosition ||
      shootingRange != oldWidget.shootingRange;

  static IdProvider of(final BuildContext context) {
    final IdProvider? result =
        context.dependOnInheritedWidgetOfExactType<IdProvider>();
    assert(result != null, "No Teams found in context");
    return result!;
  }
}

class TeamProvider extends InheritedWidget {
  TeamProvider({
    required final Widget child,
    required final List<LightTeam> teams,
  }) : this._inner(
          child: child,
          numberToTeam: Map<int, LightTeam>.unmodifiable(
            <int, LightTeam>{for (final LightTeam e in teams) e.number: e},
          ),
        );
  const TeamProvider._inner({
    required super.child,
    required this.numberToTeam,
  });
  final Map<int, LightTeam> numberToTeam;
  List<LightTeam> get teams => numberToTeam.values.toList();
  @override
  bool updateShouldNotify(final TeamProvider oldWidget) =>
      numberToTeam != oldWidget.numberToTeam || teams != oldWidget.teams;

  static TeamProvider of(final BuildContext context) {
    final TeamProvider? result =
        context.dependOnInheritedWidgetOfExactType<TeamProvider>();
    assert(result != null, "No Teams found in context");
    return result!;
  }
}

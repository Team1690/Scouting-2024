import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
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
    required final Map<ShootingRange, int> shootingRange,
    required final Map<AutoGamepieceID, int> autoGamepieceLocations,
    required final Map<AutoGamepieceState, int> autoGamepieceStates,
  }) : this._inner(
          child: child,
          climb: IdTable<Climb>(climbIds),
          driveTrain: IdTable<DriveTrain>(drivetrainIds),
          drivemotor: IdTable<DriveMotor>(drivemotorIds),
          matchType: IdTable<MatchType>(matchTypeIds),
          robotFieldStatus: IdTable<RobotFieldStatus>(robotFieldStatusIds),
          faultStatus: IdTable<FaultStatus>(faultStatus),
          shootingRange: IdTable<ShootingRange>(shootingRange),
          autoGamepieceLocations:
              IdTable<AutoGamepieceID>(autoGamepieceLocations),
          autoGamepieceStates: IdTable<AutoGamepieceState>(autoGamepieceStates),
        );

  IdProvider._inner({
    required super.child,
    required this.climb,
    required this.driveTrain,
    required this.drivemotor,
    required this.matchType,
    required this.robotFieldStatus,
    required this.faultStatus,
    required this.shootingRange,
    required this.autoGamepieceLocations,
    required this.autoGamepieceStates,
  });
  final IdTable<RobotFieldStatus> robotFieldStatus;
  final IdTable<MatchType> matchType;
  final IdTable<Climb> climb;
  final IdTable<DriveTrain> driveTrain;
  final IdTable<DriveMotor> drivemotor;
  final IdTable<FaultStatus> faultStatus;
  final IdTable<ShootingRange> shootingRange;
  final IdTable<AutoGamepieceID> autoGamepieceLocations;
  final IdTable<AutoGamepieceState> autoGamepieceStates;

  @override
  bool updateShouldNotify(final IdProvider oldWidget) =>
      robotFieldStatus != oldWidget.robotFieldStatus ||
      climb != oldWidget.climb ||
      matchType != oldWidget.matchType ||
      driveTrain != oldWidget.driveTrain ||
      drivemotor != oldWidget.drivemotor ||
      faultStatus != oldWidget.faultStatus ||
      shootingRange != oldWidget.shootingRange ||
      autoGamepieceLocations != oldWidget.autoGamepieceLocations ||
      autoGamepieceStates != oldWidget.autoGamepieceStates;

  static IdProvider of(final BuildContext context) {
    final IdProvider? result =
        context.dependOnInheritedWidgetOfExactType<IdProvider>();
    assert(result != null, "No Teams found in context");
    return result!;
  }
}

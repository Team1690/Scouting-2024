import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_model.dart";

class IdTable {
  IdTable(final Map<String, int> nameToId)
      : this._inner(
          nameToId: Map<String, int>.unmodifiable(nameToId),
          idToName: Map<int, String>.unmodifiable(
            <int, String>{
              for (final MapEntry<String, int> e in nameToId.entries)
                e.value: e.key,
            },
          ),
        );

  const IdTable._inner({required this.idToName, required this.nameToId});
  final Map<String, int> nameToId;
  final Map<int, String> idToName;
}

class IdProvider extends InheritedWidget {
  IdProvider({
    required final Widget child,
    required final Map<String, int> climbIds,
    required final Map<String, int> drivetrainIds,
    required final Map<String, int> drivemotorIds,
    required final Map<String, int> matchTypeIds,
    required final Map<String, int> robotFieldStatusIds,
    required final Map<String, int> faultStatus,
    required final Map<String, int> defense,
    required final Map<String, int> startingPosition,
    required final Map<String, int> driveWheelIds,
  }) : this._inner(
          child: child,
          climb: IdTable(climbIds),
          driveTrain: IdTable(drivetrainIds),
          drivemotor: IdTable(drivemotorIds),
          matchType: IdTable(matchTypeIds),
          robotFieldStatus: IdTable(robotFieldStatusIds),
          faultStatus: IdTable(faultStatus),
          defense: IdTable(defense),
          startingPosition: IdTable(startingPosition),
          driveWheel: IdTable(driveWheelIds),
        );

  IdProvider._inner({
    required super.child,
    required this.climb,
    required this.driveTrain,
    required this.drivemotor,
    required this.matchType,
    required this.robotFieldStatus,
    required this.faultStatus,
    required this.defense,
    required this.startingPosition,
    required this.driveWheel,
  });
  final IdTable robotFieldStatus;
  final IdTable matchType;
  final IdTable climb;
  final IdTable driveTrain;
  final IdTable drivemotor;
  final IdTable faultStatus;
  final IdTable defense;
  final IdTable startingPosition;
  final IdTable driveWheel;

  @override
  bool updateShouldNotify(final IdProvider oldWidget) =>
      robotFieldStatus != oldWidget.robotFieldStatus ||
      climb != oldWidget.climb ||
      matchType != oldWidget.matchType ||
      driveTrain != oldWidget.driveTrain ||
      drivemotor != oldWidget.drivemotor ||
      faultStatus != oldWidget.faultStatus ||
      defense != oldWidget.defense ||
      startingPosition != oldWidget.startingPosition ||
      driveWheel != oldWidget.driveWheel;

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

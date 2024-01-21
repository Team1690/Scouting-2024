import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

class PitVars implements HasuraVars {
  PitVars(final BuildContext context)
      : driveTrainType = null,
        driveMotorType = null,
        driveMotorAmount = 2,
        hasShifter = null,
        gearboxPurchased = null,
        notes = "",
        driveWheelType = null,
        teamId = null,
        weight = "",
        height = "",
        canHarmonize = null,
        canTrap = 0;

  PitVars.all({
    required this.driveTrainType,
    required this.driveMotorType,
    required this.driveMotorAmount,
    required this.hasShifter,
    required this.gearboxPurchased,
    required this.notes,
    required this.driveWheelType,
    required this.teamId,
    required this.weight,
    required this.height,
    required this.canHarmonize,
    required this.canTrap,
  });

  PitVars copyWith({
    final int? Function()? driveTrainType,
    final int? Function()? driveMotorType,
    final int Function()? driveMotorAmount,
    final bool? Function()? hasShifter,
    final bool? Function()? gearboxPurchased,
    final String Function()? notes,
    final String? Function()? driveWheelType,
    final int? Function()? teamId,
    final String Function()? weight,
    final String Function()? height,
    final bool? Function()? canHarmonize,
    final int Function()? canTrap,
  }) =>
      PitVars.all(
        driveTrainType:
            driveTrainType != null ? driveTrainType() : this.driveTrainType,
        driveMotorType:
            driveMotorType != null ? driveMotorType() : this.driveMotorType,
        driveMotorAmount: driveMotorAmount != null
            ? driveMotorAmount()
            : this.driveMotorAmount,
        hasShifter: hasShifter != null ? hasShifter() : this.hasShifter,
        gearboxPurchased: gearboxPurchased != null
            ? gearboxPurchased()
            : this.gearboxPurchased,
        notes: notes != null ? notes() : this.notes,
        driveWheelType:
            driveWheelType != null ? driveWheelType() : this.driveWheelType,
        teamId: teamId != null ? teamId() : this.teamId,
        weight: weight != null ? weight() : this.weight,
        height: height != null ? height() : this.height,
        canHarmonize: canHarmonize != null ? canHarmonize() : this.canHarmonize,
        canTrap: canTrap != null ? canTrap() : this.canTrap,
      );
  //TODO add season specific vars
  final int? driveTrainType;
  final int? driveMotorType;
  final int driveMotorAmount;
  final bool? hasShifter;
  final bool? gearboxPurchased;
  final String notes;
  final String? driveWheelType;
  final int? teamId;
  final String weight;
  final String height;
  final bool? canHarmonize;
  final int canTrap;
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        //TODO add season specific vars
        "drivetrain_id": driveTrainType,
        "drivemotor_id": driveMotorType,
        "drive_motor_amount": driveMotorAmount,
        "has_shifter": hasShifter,
        "gearbox_purchased": gearboxPurchased,
        "notes": notes,
        "drive_wheel_type": driveWheelType ?? "",
        "team_id": teamId,
        "weight": int.parse(weight),
        "height": int.parse(height),
        "can_harmonize": canHarmonize,
        "canTrap": canTrap,
      };

  void reset() {
    copyWith(
      driveTrainType: always(null),
      driveMotorType: always(null),
      driveMotorAmount: always(2),
      hasShifter: always(null),
      gearboxPurchased: always(null),
      notes: always(""),
      driveWheelType: always(null),
      teamId: always(null),
      weight: always(""),
      height: always(""),
      canHarmonize: always(null),
      canTrap: always(0),
    );
  }
}

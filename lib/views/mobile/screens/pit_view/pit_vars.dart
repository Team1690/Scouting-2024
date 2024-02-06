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
        otherDriveWheelType = null,
        teamId = null,
        weight = null,
        height = null,
        harmony = null,
        trap = 0,
        hasBuddyClimb = null,
        kg = true,
        m = true;

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
    required this.harmony,
    required this.trap,
    required this.hasBuddyClimb,
    required this.otherDriveWheelType,
    required this.kg,
    required this.m,
  });

  PitVars copyWith({
    final int? Function()? driveTrainType,
    final int? Function()? driveMotorType,
    final int Function()? driveMotorAmount,
    final bool? Function()? hasShifter,
    final bool? Function()? gearboxPurchased,
    final String Function()? notes,
    final int? Function()? driveWheelType,
    final String? Function()? otherDriveWheelType,
    final int? Function()? teamId,
    final double? Function()? weight,
    final double? Function()? height,
    final bool? Function()? harmony,
    final int Function()? trap,
    final bool? Function()? hasBuddyClimb,
    final bool Function()? kg,
    final bool Function()? m,
  }) =>
      PitVars.all(
        driveTrainType:
            driveTrainType != null ? driveTrainType() : this.driveTrainType,
        driveMotorType:
            driveMotorType != null ? driveMotorType() : this.driveMotorType,
        driveMotorAmount: driveMotorAmount != null
            ? driveMotorAmount()
            : this.driveMotorAmount,
        otherDriveWheelType: otherDriveWheelType != null
            ? otherDriveWheelType()
            : this.otherDriveWheelType,
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
        harmony: harmony != null ? harmony() : this.harmony,
        trap: trap != null ? trap() : this.trap,
        hasBuddyClimb:
            hasBuddyClimb != null ? hasBuddyClimb() : this.hasBuddyClimb,
        kg: kg != null ? kg() : this.kg,
        m: m != null ? m() : this.m,
      );
  final int? driveTrainType;
  final int? driveMotorType;
  final int driveMotorAmount;
  final bool? hasShifter;
  final bool? gearboxPurchased;
  final bool kg;
  final String notes;
  final int? driveWheelType;
  final String? otherDriveWheelType;
  final int? teamId;
  final double? weight;
  final double? height;
  final bool? harmony;
  final int trap;
  final bool? hasBuddyClimb;
  final bool m;
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "drivetrain_id": driveTrainType,
        "drivemotor_id": driveMotorType,
        "drive_motor_amount": driveMotorAmount,
        "has_shifter": hasShifter,
        "gearbox_purchased": gearboxPurchased,
        "notes": notes,
        "wheel_type_id": driveWheelType,
        "other_wheel_type": otherDriveWheelType,
        "team_id": teamId,
        "weight": weight,
        "height": height,
        "harmony": harmony,
        "trap": trap,
        "has_buddy_climb": hasBuddyClimb,
        "kg": kg,
        "meters": m
      };

  PitVars reset() => copyWith(
      driveTrainType: always(null),
      driveMotorType: always(null),
      driveMotorAmount: always(2),
      hasShifter: always(null),
      gearboxPurchased: always(null),
      notes: always(""),
      driveWheelType: always(null),
      teamId: always(null),
      weight: always(null),
      height: always(null),
      harmony: always(null),
      trap: always(0),
      hasBuddyClimb: always(null),
      otherDriveWheelType: always(null),
      kg: always(true),
      m: always(true));
}

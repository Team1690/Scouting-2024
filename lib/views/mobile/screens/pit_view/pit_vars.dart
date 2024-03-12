import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

class PitVars implements HasuraVars {
  PitVars(final BuildContext context)
      : driveTrainType = null,
        driveMotorType = null,
        notes = "",
        teamId = null,
        weight = null,
        harmony = null,
        trap = 0,
        url = null,
        canEject = null,
        canPassUnderStage = null,
        length = null,
        width = null,
        allRangeShooting = null,
        climb = null;

  PitVars.all({
    required this.driveTrainType,
    required this.driveMotorType,
    required this.notes,
    required this.teamId,
    required this.weight,
    required this.harmony,
    required this.trap,
    required this.canPassUnderStage,
    required this.url,
    required this.canEject,
    required this.length,
    required this.width,
    required this.allRangeShooting,
    required this.climb,
  });

  PitVars copyWith({
    final DriveTrain? Function()? driveTrainType,
    final DriveMotor? Function()? driveMotorType,
    final String Function()? notes,
    final int? Function()? teamId,
    final double? Function()? weight,
    final double? Function()? length,
    final double? Function()? width,
    final bool? Function()? harmony,
    final int Function()? trap,
    final String? Function()? url,
    final bool? Function()? canEject,
    final bool? Function()? canPassUnderStage,
    final bool? Function()? allRangeShooting,
    final bool? Function()? climb,
  }) =>
      PitVars.all(
        driveTrainType:
            driveTrainType != null ? driveTrainType() : this.driveTrainType,
        driveMotorType:
            driveMotorType != null ? driveMotorType() : this.driveMotorType,
        notes: notes != null ? notes() : this.notes,
        teamId: teamId != null ? teamId() : this.teamId,
        weight: weight != null ? weight() : this.weight,
        length: length != null ? length() : this.length,
        width: width != null ? width() : this.width,
        harmony: harmony != null ? harmony() : this.harmony,
        trap: trap != null ? trap() : this.trap,
        url: url != null ? url() : this.url,
        canEject: canEject != null ? canEject() : this.canEject,
        canPassUnderStage: canPassUnderStage != null
            ? canPassUnderStage()
            : this.canPassUnderStage,
        allRangeShooting: allRangeShooting != null
            ? allRangeShooting()
            : this.allRangeShooting,
        climb: climb != null ? climb() : this.climb,
      );
  final DriveTrain? driveTrainType;
  final DriveMotor? driveMotorType;
  final String notes;
  final int? teamId;
  final double? weight;
  final double? length;
  final double? width;
  final bool? canPassUnderStage;
  final bool? harmony;
  final int trap;
  final String? url;
  final bool? canEject;
  final bool? allRangeShooting;
  final bool? climb;
  @override
  Map<String, dynamic> toJson(final BuildContext context) => <String, dynamic>{
        "drivetrain_id":
            IdProvider.of(context).driveTrain.enumToId[driveTrainType]!,
        "drivemotor_id":
            IdProvider.of(context).drivemotor.enumToId[driveMotorType],
        "notes": notes,
        "team_id": teamId,
        "weight": weight,
        "length": length,
        "width": width,
        "harmony": harmony ?? false,
        "trap": trap,
        "can_pass_under_stage": canPassUnderStage,
        "url": url,
        "can_eject": canEject ?? false,
        "all_range_shooting": allRangeShooting ?? false,
        "climb": climb,
      };

  PitVars reset() => copyWith(
        driveTrainType: always(null),
        driveMotorType: always(null),
        notes: always(""),
        teamId: always(null),
        weight: always(null),
        length: always(null),
        width: always(null),
        harmony: always(null),
        trap: always(0),
        canPassUnderStage: always(null),
        url: always(null),
        canEject: always(null),
        allRangeShooting: always(null),
        climb: always(null),
      );
}

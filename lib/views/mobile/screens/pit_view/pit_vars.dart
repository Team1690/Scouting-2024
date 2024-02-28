import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
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
        width = null;

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
  });

  PitVars copyWith({
    final int? Function()? driveTrainType,
    final int? Function()? driveMotorType,
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
      );
  final int? driveTrainType;
  final int? driveMotorType;
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
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "drivetrain_id": driveTrainType,
        "drivemotor_id": driveMotorType,
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
      );
}

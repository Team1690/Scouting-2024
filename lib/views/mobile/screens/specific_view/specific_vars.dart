import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";

class SpecificVars implements HasuraVars {
  SpecificVars(final BuildContext context)
      : team = null,
        driveRating = null,
        intakeRating = null,
        speakerRating = null,
        ampRating = null,
        defenseRating = null,
        climbRating = null,
        generalRating = null,
        scheduleMatch = null,
        name = "",
        isRematch = false,
        faultMessage = null,
        autoPath = null;

  SpecificVars.all({
    required this.team,
    required this.driveRating,
    required this.intakeRating,
    required this.speakerRating,
    required this.ampRating,
    required this.defenseRating,
    required this.climbRating,
    required this.generalRating,
    required this.scheduleMatch,
    required this.name,
    required this.isRematch,
    required this.faultMessage,
    required this.autoPath,
  });

  SpecificVars copyWith({
    final LightTeam? Function()? team,
    final int? Function()? driveRating,
    final int? Function()? intakeRating,
    final int? Function()? speakerRating,
    final int? Function()? ampRating,
    final int? Function()? defenseRating,
    final int? Function()? climbRating,
    final int? Function()? generalRating,
    final ScheduleMatch? Function()? scheduleMatch,
    final String Function()? name,
    final bool Function()? isRematch,
    final String? Function()? faultMessage,
    final Sketch? Function()? autoPath,
  }) =>
      SpecificVars.all(
        team: team != null ? team() : this.team,
        driveRating: driveRating != null ? driveRating() : this.driveRating,
        intakeRating: intakeRating != null ? intakeRating() : this.intakeRating,
        speakerRating:
            speakerRating != null ? speakerRating() : this.speakerRating,
        ampRating: ampRating != null ? ampRating() : this.ampRating,
        defenseRating:
            defenseRating != null ? defenseRating() : this.defenseRating,
        climbRating: climbRating != null ? climbRating() : this.climbRating,
        generalRating:
            generalRating != null ? generalRating() : this.generalRating,
        scheduleMatch:
            scheduleMatch != null ? scheduleMatch() : this.scheduleMatch,
        name: name != null ? name() : this.name,
        isRematch: isRematch != null ? isRematch() : this.isRematch,
        faultMessage: faultMessage != null ? faultMessage() : this.faultMessage,
        autoPath: autoPath != null ? autoPath() : this.autoPath,
      );

  final LightTeam? team;
  final int? driveRating;
  final int? intakeRating;
  final int? speakerRating;
  final int? ampRating;
  final int? defenseRating;
  final int? climbRating;
  final int? generalRating;
  final ScheduleMatch? scheduleMatch;
  final String name;
  final bool isRematch;
  final String? faultMessage;
  final Sketch? autoPath;
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "team_id": team?.id,
        if (autoPath!.url != null) "url": autoPath!.url!,
        "driving_rating": driveRating,
        "intake_rating": intakeRating,
        "climb_rating": climbRating,
        "amp_rating": ampRating,
        "speaker_rating": speakerRating,
        "defense_rating": defenseRating,
        "general_rating": generalRating,
        "is_rematch": isRematch,
        "schedule_match_id": scheduleMatch?.id,
        "scouter_name": name,
        if (faultMessage != null) "schedule_match_id": scheduleMatch?.id,
      };

  SpecificVars reset(final BuildContext context) => copyWith(
        isRematch: always(false),
        scheduleMatch: always(null),
        faultMessage: always(null),
        team: always(null),
        driveRating: always(null),
        climbRating: always(null),
        intakeRating: always(null),
        ampRating: always(null),
        speakerRating: always(null),
        defenseRating: always(null),
        generalRating: always(null),
        autoPath: always(null),
      );
}

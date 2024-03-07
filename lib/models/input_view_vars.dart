import "package:flutter/cupertino.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

import "package:orbit_standard_library/orbit_standard_library.dart";

class InputViewVars implements HasuraVars {
  InputViewVars(final BuildContext context)
      : isRematch = false,
        isDeliverd = false,
        isDefence = false,
        scheduleMatch = null,
        scouterName = "",
        robotFieldStatusId =
            IdProvider.of(context).robotFieldStatus.nameToId["Worked"]!,
        autoAmp = 0,
        autoAmpMissed = 0,
        autoSpeaker = 0,
        autoSpeakerMissed = 0,
        teleAmp = 0,
        teleAmpMissed = 0,
        teleSpeaker = 0,
        teleSpeakerMissed = 0,
        climbId = null,
        harmonyWith = 0,
        trapAmount = 0,
        trapsMissed = 0,
        scoutedTeam = null;
  InputViewVars.all({
    required this.isDefence,
    required this.isDeliverd,
    required this.trapsMissed,
    required this.isRematch,
    required this.scheduleMatch,
    required this.scouterName,
    required this.robotFieldStatusId,
    required this.autoAmp,
    required this.autoAmpMissed,
    required this.autoSpeaker,
    required this.autoSpeakerMissed,
    required this.teleAmp,
    required this.teleAmpMissed,
    required this.teleSpeaker,
    required this.teleSpeakerMissed,
    required this.climbId,
    required this.harmonyWith,
    required this.trapAmount,
    required this.scoutedTeam,
  });

  InputViewVars cleared(final BuildContext context) =>
      InputViewVars(context).copyWith(scouterName: always(scouterName));

  InputViewVars copyWith({
    final bool Function()? isDeliverd,
    final bool Function()? isDefence,
    final bool Function()? isRematch,
    final ScheduleMatch? Function()? scheduleMatch,
    final String? Function()? scouterName,
    final int Function()? robotFieldStatusId,
    final int Function()? autoAmp,
    final int Function()? autoAmpMissed,
    final int Function()? autoSpeaker,
    final int Function()? autoSpeakerMissed,
    final int Function()? teleAmp,
    final int Function()? teleAmpMissed,
    final int Function()? teleSpeaker,
    final int Function()? teleSpeakerMissed,
    final int Function()? climbId,
    final int Function()? harmonyWith,
    final int Function()? trapAmount,
    final int Function()? trapsMissed,
    final LightTeam? Function()? scoutedTeam,
  }) =>
      InputViewVars.all(
        isRematch: isRematch != null ? isRematch() : this.isRematch,
        scheduleMatch:
            scheduleMatch != null ? scheduleMatch() : this.scheduleMatch,
        scouterName: scouterName != null ? scouterName() : this.scouterName,
        robotFieldStatusId: robotFieldStatusId != null
            ? robotFieldStatusId()
            : this.robotFieldStatusId,
        autoAmp: autoAmp != null ? autoAmp() : this.autoAmp,
        autoAmpMissed:
            autoAmpMissed != null ? autoAmpMissed() : this.autoAmpMissed,
        autoSpeaker: autoSpeaker != null ? autoSpeaker() : this.autoSpeaker,
        autoSpeakerMissed: autoSpeakerMissed != null
            ? autoSpeakerMissed()
            : this.autoSpeakerMissed,
        teleAmp: teleAmp != null ? teleAmp() : this.teleAmp,
        teleAmpMissed:
            teleAmpMissed != null ? teleAmpMissed() : this.teleAmpMissed,
        teleSpeaker: teleSpeaker != null ? teleSpeaker() : this.teleSpeaker,
        teleSpeakerMissed: teleSpeakerMissed != null
            ? teleSpeakerMissed()
            : this.teleSpeakerMissed,
        climbId: climbId != null ? climbId() : this.climbId,
        harmonyWith: harmonyWith != null ? harmonyWith() : this.harmonyWith,
        trapAmount: trapAmount != null ? trapAmount() : this.trapAmount,
        trapsMissed: trapsMissed != null ? trapsMissed() : this.trapsMissed,
        scoutedTeam: scoutedTeam != null ? scoutedTeam() : this.scoutedTeam,
        isDefence: isDefence != null ? isDefence() : this.isDefence,
        isDeliverd: isDeliverd != null ? isDeliverd() : this.isDeliverd,
      );

  final bool isDeliverd;
  final bool isDefence;
  final bool isRematch;
  final ScheduleMatch? scheduleMatch;
  final String? scouterName;
  final int robotFieldStatusId;
  final int autoAmp;
  final int autoAmpMissed;
  final int autoSpeaker;
  final int autoSpeakerMissed;
  final int teleAmp;
  final int teleAmpMissed;
  final int teleSpeaker;
  final int teleSpeakerMissed;
  final int? climbId;
  final int harmonyWith;
  final int trapAmount;
  final int trapsMissed;
  final LightTeam? scoutedTeam;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "is_defence": isDefence,
        "is_deliverd": isDeliverd,
        "team_id": scoutedTeam?.id,
        "scouter_name": scouterName,
        "schedule_id": scheduleMatch?.id,
        "robot_field_status_id": robotFieldStatusId,
        "is_rematch": isRematch,
        "auto_amp": autoAmp,
        "auto_amp_missed": autoAmpMissed,
        "auto_speaker": autoSpeaker,
        "auto_speaker_missed": autoSpeakerMissed,
        "tele_amp": teleAmp,
        "tele_amp_missed": teleAmpMissed,
        "tele_speaker": teleSpeaker,
        "tele_speaker_missed": teleSpeakerMissed,
        "climb_id": climbId,
        "harmony_with": harmonyWith,
        "trap_amount": trapAmount,
        "traps_missed": trapsMissed,
      };
}

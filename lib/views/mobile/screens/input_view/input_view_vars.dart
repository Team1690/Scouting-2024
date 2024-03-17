import "package:flutter/cupertino.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/autonomous/auto_gamepieces.dart";

class InputViewVars implements HasuraVars {
  InputViewVars()
      : isRematch = false,
        scheduleMatch = null,
        scouterName = "",
        robotFieldStatus = RobotFieldStatus.worked,
        delivery = 0,
        teleAmp = 0,
        teleAmpMissed = 0,
        teleSpeaker = 0,
        teleSpeakerMissed = 0,
        climb = null,
        harmonyWith = 0,
        trapAmount = 0,
        trapsMissed = 0,
        scoutedTeam = null,
        autoOrder = <AutoGamepieceID>[],
        autoGamepieces = AutoGamepieces.base();
  InputViewVars.all({
    required this.autoOrder,
    required this.delivery,
    required this.trapsMissed,
    required this.isRematch,
    required this.scheduleMatch,
    required this.scouterName,
    required this.robotFieldStatus,
    required this.teleAmp,
    required this.teleAmpMissed,
    required this.teleSpeaker,
    required this.teleSpeakerMissed,
    required this.climb,
    required this.harmonyWith,
    required this.trapAmount,
    required this.scoutedTeam,
    required this.autoGamepieces,
  });

  InputViewVars cleared() =>
      InputViewVars().copyWith(scouterName: always(scouterName));

  InputViewVars copyWith({
    final bool Function()? isRematch,
    final ScheduleMatch? Function()? scheduleMatch,
    final String? Function()? scouterName,
    final RobotFieldStatus Function()? robotFieldStatus,
    final int Function()? teleAmp,
    final int Function()? teleAmpMissed,
    final int Function()? teleSpeaker,
    final int Function()? teleSpeakerMissed,
    final Climb Function()? climb,
    final int Function()? harmonyWith,
    final int Function()? trapAmount,
    final int Function()? trapsMissed,
    final LightTeam? Function()? scoutedTeam,
    final int Function()? delivery,
    final AutoGamepieces Function()? autoGamepieces,
    final List<AutoGamepieceID> Function()? autoOrder,
  }) =>
      InputViewVars.all(
        isRematch: isRematch != null ? isRematch() : this.isRematch,
        scheduleMatch:
            scheduleMatch != null ? scheduleMatch() : this.scheduleMatch,
        scouterName: scouterName != null ? scouterName() : this.scouterName,
        robotFieldStatus: robotFieldStatus != null
            ? robotFieldStatus()
            : this.robotFieldStatus,
        teleAmp: teleAmp != null ? teleAmp() : this.teleAmp,
        teleAmpMissed:
            teleAmpMissed != null ? teleAmpMissed() : this.teleAmpMissed,
        teleSpeaker: teleSpeaker != null ? teleSpeaker() : this.teleSpeaker,
        teleSpeakerMissed: teleSpeakerMissed != null
            ? teleSpeakerMissed()
            : this.teleSpeakerMissed,
        climb: climb != null ? climb() : this.climb,
        harmonyWith: harmonyWith != null ? harmonyWith() : this.harmonyWith,
        trapAmount: trapAmount != null ? trapAmount() : this.trapAmount,
        trapsMissed: trapsMissed != null ? trapsMissed() : this.trapsMissed,
        scoutedTeam: scoutedTeam != null ? scoutedTeam() : this.scoutedTeam,
        delivery: delivery != null ? delivery() : this.delivery,
        autoGamepieces:
            autoGamepieces != null ? autoGamepieces() : this.autoGamepieces,
        autoOrder: autoOrder != null ? autoOrder() : this.autoOrder,
      );

  final List<AutoGamepieceID> autoOrder;
  final int delivery;
  final bool isRematch;
  final ScheduleMatch? scheduleMatch;
  final String? scouterName;
  final RobotFieldStatus robotFieldStatus;
  final int teleAmp;
  final int teleAmpMissed;
  final int teleSpeaker;
  final int teleSpeakerMissed;
  final Climb? climb;
  final int harmonyWith;
  final int trapAmount;
  final int trapsMissed;
  final LightTeam? scoutedTeam;
  final AutoGamepieces autoGamepieces;

  @override
  Map<String, dynamic> toJson(final BuildContext context) => <String, dynamic>{
        "team_id": scoutedTeam?.id,
        "scouter_name": scouterName,
        "schedule_id": scheduleMatch?.id,
        "robot_field_status_id":
            IdProvider.of(context).robotFieldStatus.enumToId[robotFieldStatus]!,
        "is_rematch": isRematch,
        "tele_amp": teleAmp,
        "tele_amp_missed": teleAmpMissed,
        "tele_speaker": teleSpeaker,
        "tele_speaker_missed": teleSpeakerMissed,
        "climb_id": IdProvider.of(context).climb.enumToId[climb]!,
        "harmony_with": harmonyWith,
        "trap_amount": trapAmount,
        "traps_missed": trapsMissed,
        "delivery": delivery,
        "L0_id": IdProvider.of(context)
            .autoGamepieceStates
            .enumToId[autoGamepieces.l0]!,
        "L1_id": IdProvider.of(context)
            .autoGamepieceStates
            .enumToId[autoGamepieces.l1]!,
        "L2_id": IdProvider.of(context)
            .autoGamepieceStates
            .enumToId[autoGamepieces.l2]!,
        "M0_id": IdProvider.of(context)
            .autoGamepieceStates
            .enumToId[autoGamepieces.m0]!,
        "M1_id": IdProvider.of(context)
            .autoGamepieceStates
            .enumToId[autoGamepieces.m1]!,
        "M2_id": IdProvider.of(context)
            .autoGamepieceStates
            .enumToId[autoGamepieces.m2]!,
        "M3_id": IdProvider.of(context)
            .autoGamepieceStates
            .enumToId[autoGamepieces.m3]!,
        "M4_id": IdProvider.of(context)
            .autoGamepieceStates
            .enumToId[autoGamepieces.m4]!,
        "R0_id": IdProvider.of(context)
            .autoGamepieceStates
            .enumToId[autoGamepieces.r0]!,
        "auto_order":
            autoOrder.map((final AutoGamepieceID e) => e.title).join(","),
      };
}

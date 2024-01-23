import "package:flutter/cupertino.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/matches_model.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

import "package:orbit_standard_library/orbit_standard_library.dart";

class Match implements HasuraVars {
  Match(final BuildContext context)
      : isRematch = false,
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
        startingPositionID = null,
        scoutedTeam = null;
  Match.all({
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
    required this.startingPositionID,
  });

  Match cleared(final BuildContext context) =>
      Match(context).copyWith(scouterName: always(scouterName));

  Match copyWith({
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
    final int Function()? startingPositionID,
    final LightTeam? Function()? scoutedTeam,
  }) =>
      Match.all(
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
        scoutedTeam: scoutedTeam != null ? scoutedTeam() : this.scoutedTeam,
        startingPositionID: startingPositionID != null
            ? startingPositionID()
            : this.startingPositionID,
      );

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
  final int? startingPositionID;
  final LightTeam? scoutedTeam;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "team_id": scoutedTeam?.id,
        "scouter_name": scouterName,
        "schedule_id": scheduleMatch?.id,
        "robot_field_status_id": robotFieldStatusId,
        "is_rematch": isRematch,
        "auto_amp": autoAmp,
        "auto_amp_missed": autoAmpMissed,
        "auto_speaker": autoSpeaker,
        "auto_speaker_missed": autoAmpMissed,
        "tele_amp": teleAmp,
        "tele_amp_missed": teleAmpMissed,
        "tele_speaker": teleSpeaker,
        "tele_speaker_missed": teleAmpMissed,
        "climb_id": climbId,
        "harmony_with": harmonyWith,
        "trap_amount": trapAmount,
        "starting_position_id": startingPositionID,
      };
}

enum MatchMode {
  auto(1, "auto"),
  tele(0, "tele");

  const MatchMode(this.pointAddition, this.title);
  final int pointAddition;
  final String title;
}

enum PlaceLocation {
  speaker("speaker"),
  amp("amp");

  const PlaceLocation(this.title);
  final String title;
}

class EffectiveScore {
  const EffectiveScore({
    required this.mode,
    required this.place,
  });
  final MatchMode mode;
  final PlaceLocation place;

  @override
  int get hashCode => Object.hashAll(<Object?>[
        mode,
        place,
      ]);

  @override
  bool operator ==(final Object other) =>
      other is EffectiveScore && other.mode == mode && other.place == place;
}

List<EffectiveScore> speakerAndAmp(final MatchMode mode) => <EffectiveScore>[
      EffectiveScore(
        mode: mode,
        place: PlaceLocation.speaker,
      ),
      EffectiveScore(
        mode: mode,
        place: PlaceLocation.amp,
      ),
    ];

final Map<EffectiveScore, int> score = <EffectiveScore, int>{
  ...MatchMode.values.toList().asMap().map(
        (final int index, final MatchMode mode) =>
            MapEntry<EffectiveScore, int>(
          EffectiveScore(mode: mode, place: PlaceLocation.speaker),
          mode.pointAddition,
        ),
      ),
};

double getPoints(final Map<EffectiveScore, double> countedValues) =>
    countedValues.keys.fold(
      0,
      (final double points, final EffectiveScore effectiveScore) =>
          countedValues[effectiveScore]! * score[effectiveScore]! + points,
    );

double getPieces(final Map<EffectiveScore, double> countedValues) =>
    countedValues.keys.fold(
      0,
      (final double gamepieces, final EffectiveScore effectiveScore) =>
          countedValues[effectiveScore]! + gamepieces,
    );

Map<EffectiveScore, double> parseByMode(
  final MatchMode mode,
  final dynamic data,
) =>
    Map<EffectiveScore, double>.fromEntries(
      speakerAndAmp(mode).map(
        (final EffectiveScore e) => MapEntry<EffectiveScore, double>(
          e,
          data["${e.mode.title}_${e.place.title}"] as double,
        ),
      ),
    );

Map<EffectiveScore, double> parseMatch(
  final dynamic data,
) =>
    <EffectiveScore, double>{
      ...parseByMode(MatchMode.auto, data),
      ...parseByMode(MatchMode.tele, data),
    };

import "package:flutter/cupertino.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/matches_model.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

import "package:orbit_standard_library/orbit_standard_library.dart";

class Match implements HasuraVars {
  Match({
    this.scoutedTeam,
    required this.robotMatchStatusId,
    this.isRematch = false,
    this.startingPositionId,
    //TODO add season specific vars
  });

  void clear(final BuildContext context) {
    startingPositionId = null;
    scoutedTeam = null;
    scheduleMatch = null;
    isRematch = false;
    robotMatchStatusId =
        IdProvider.of(context).robotMatchStatus.nameToId["Worked"]!;
    //TODO add season specific vars
  }

  bool preScouting = false;
  bool isRematch;
  ScheduleMatch? scheduleMatch;
  String? name;
  int robotMatchStatusId;
  int? startingPositionId;
  //TODO add season specific vars

  LightTeam? scoutedTeam;
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "team_id": scoutedTeam?.id,
        "scouter_name": name,
        "schedule_match_id": scheduleMatch?.id,
        "robot_match_status_id": robotMatchStatusId,
        "is_rematch": isRematch,
        "starting_position_id": startingPositionId,
        //TODO add season specific vars
      };
}

enum MatchMode {
  auto(1, "auto"),
  tele(0, "tele");

  const MatchMode(this.pointAddition, this.title);
  final int pointAddition;
  final String title;
}

enum Gamepiece {
  cone("cones"),
  cube("cubes");

  const Gamepiece(this.title);
  final String title;
}

enum GridLevel {
  top(5, "top"),
  mid(3, "mid"),
  low(2, "low"),
  none(0, "delivered");

  const GridLevel(this.points, this.title);
  final int points;
  final String title;
}

class EffectiveScore {
  const EffectiveScore({
    required this.mode,
    required this.piece,
    required this.level,
  });
  final MatchMode mode;
  final Gamepiece piece;
  final GridLevel? level;

  @override
  int get hashCode => Object.hashAll(<Object?>[
        mode,
        piece,
        level,
      ]);

  @override
  bool operator ==(final Object other) =>
      other is EffectiveScore &&
      other.level == level &&
      other.mode == mode &&
      other.piece == piece;
}

List<EffectiveScore> coneAndCube(final GridLevel level, final MatchMode mode) =>
    <EffectiveScore>[
      EffectiveScore(
        mode: mode,
        piece: Gamepiece.cone,
        level: level,
      ),
      EffectiveScore(
        mode: mode,
        piece: Gamepiece.cube,
        level: level,
      ),
    ];

List<EffectiveScore> allLevel(final MatchMode mode) => <EffectiveScore>[
      ...GridLevel.values
          .map((final GridLevel level) => coneAndCube(level, mode))
          .expand(identity),
    ];

final Map<EffectiveScore, int> score = <EffectiveScore, int>{
  ...MatchMode.values.map(allLevel).expand(identity).toList().asMap().map(
        (final _, final EffectiveScore effectiveScore) =>
            MapEntry<EffectiveScore, int>(
          effectiveScore,
          effectiveScore.level!.points +
              (effectiveScore.level != GridLevel.none
                  ? effectiveScore.mode.pointAddition
                  : 0), //this can be null since we define each EffectiveScore here to have a level (aka not missed)
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
      allLevel(mode).map(
        (final EffectiveScore e) => MapEntry<EffectiveScore, double>(
          e,
          data["${e.mode.title}_${e.piece.title}_${e.level!.title}"] as double,
        ),
      ),
    ); //we define these values, therefore they are not null (see 'allLevel()')

Map<EffectiveScore, double> parseMatch(
  final dynamic data,
) =>
    <EffectiveScore, double>{
      ...parseByMode(MatchMode.auto, data),
      ...parseByMode(MatchMode.tele, data),
    };

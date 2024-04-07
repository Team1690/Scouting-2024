import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

class MatchesVars implements HasuraVars {
  MatchesVars({
    this.matchesIdToUpdate,
    this.matchNumber,
    this.blue0,
    this.blue1,
    this.blue2,
    this.blue3,
    this.happened = false,
    this.matchType,
    this.red0,
    this.red1,
    this.red2,
    this.red3,
  });

  MatchesVars.fromScheduleMatch(
    final ScheduleMatch match,
    final BuildContext context,
  ) : this(
          blue0: match.blueAlliance[0],
          blue1: match.blueAlliance[1],
          blue2: match.blueAlliance[2],
          blue3: match.blueAlliance.length == 4 ? match.blueAlliance[3] : null,
          happened: match.happened,
          matchNumber: match.matchIdentifier.number,
          matchType: match.matchIdentifier.type,
          matchesIdToUpdate: match.id,
          red0: match.redAlliance[0],
          red1: match.redAlliance[1],
          red2: match.redAlliance[2],
          red3: match.redAlliance.length == 4 ? match.redAlliance[3] : null,
        );
  int? matchNumber;
  MatchType? matchType;
  final int? matchesIdToUpdate;
  LightTeam? blue0;
  LightTeam? blue1;
  LightTeam? blue2;
  LightTeam? blue3;
  LightTeam? red0;
  LightTeam? red1;
  LightTeam? red2;
  LightTeam? red3;
  bool happened;
  @override
  Map<String, dynamic> toJson(final BuildContext context) => <String, dynamic>{
        if (matchesIdToUpdate != null) "id": matchesIdToUpdate,
        "match": <String, dynamic>{
          "match_number": matchNumber,
          "match_type_id": IdProvider.of(context).matchType.enumToId[matchType],
          "blue_0_id": blue0?.id,
          "blue_1_id": blue1?.id,
          "blue_2_id": blue2?.id,
          "blue_3_id": blue3?.id,
          "red_0_id": red0?.id,
          "red_1_id": red1?.id,
          "red_2_id": red2?.id,
          "red_3_id": red3?.id,
          "happened": happened,
        },
      };

  void reset() {
    matchNumber = null;
    matchType = null;
    blue0 = null;
    blue1 = null;
    blue2 = null;
    blue3 = null;
    red0 = null;
    red1 = null;
    red2 = null;
    red3 = null;
    happened = false;
  }
}

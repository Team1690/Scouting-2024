import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_model.dart";

class StatusLightTeam {
  const StatusLightTeam(
    this.points,
    this.allianceColor,
    this.team,
    this.alliancePos,
  );
  final LightTeam team;
  final int points;
  final Color allianceColor;
  final int alliancePos;
}

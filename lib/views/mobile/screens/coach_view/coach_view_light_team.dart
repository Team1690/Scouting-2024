import "package:scouting_frontend/models/team_model.dart";

class CoachViewLightTeam {
  const CoachViewLightTeam({
    required this.team,
    required this.isBlue,
    required this.faults,
  });
  final LightTeam team;
  final bool isBlue;
  final List<String>? faults;
}

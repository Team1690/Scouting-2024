import "package:scouting_frontend/models/team_model.dart";

class CoachData {
  const CoachData({
    required this.happened,
    required this.blueAlliance,
    required this.redAlliance,
    required this.matchNumber,
    required this.matchType,
    required this.avgBlue,
    required this.avgRed,
    required this.avgBlueWithFourth,
    required this.avgRedWithFourth,
  });
  final int matchNumber;
  final bool happened;
  final List<LightTeam> blueAlliance;
  final List<LightTeam> redAlliance;
  final String matchType;
  final double avgBlueWithFourth;
  final double avgRedWithFourth;
  final double avgBlue;
  final double avgRed;
}

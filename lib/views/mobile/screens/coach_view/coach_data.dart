import "package:scouting_frontend/views/mobile/screens/coach_view/coach_view_light_team.dart";

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
  final List<CoachViewLightTeam> blueAlliance;
  final List<CoachViewLightTeam> redAlliance;
  final String matchType;
  final double avgBlueWithFourth;
  final double avgRedWithFourth;
  final double avgBlue;
  final double avgRed;
}

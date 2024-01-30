import "package:scouting_frontend/models/team_model.dart";

class AllTeamData {
  AllTeamData({
    required this.team,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
    required this.gamesClimbed,
    required this.autoGamepieceAvg,
    required this.teleGamepieceAvg,
    required this.gamepieceAvg,
    required this.missedAvg,
    required this.gamepiecePointAvg,
    required this.brokenMatches,
    required this.amountOfMatches,
    required this.matchesBalanced,
    required this.trapAverage,
  });
  final LightTeam team;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
  final int gamesClimbed;
  final double autoGamepieceAvg;
  final double teleGamepieceAvg;
  final double gamepieceAvg;
  final double missedAvg;
  final double gamepiecePointAvg;
  final double trapAverage;
  final int brokenMatches;
  final int amountOfMatches;
  final int matchesBalanced;
}

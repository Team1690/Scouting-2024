import "package:scouting_frontend/models/team_model.dart";

class AllTeamData {
  AllTeamData(
      {required this.team,
      required this.firstPicklistIndex,
      required this.secondPicklistIndex,
      required this.autoGamepieceAvg,
      required this.teleGamepieceAvg,
      required this.gamepieceAvg,
      required this.missedAvg,
      required this.gamepiecePointAvg,
      required this.brokenMatches,
      required this.amountOfMatches,
      required this.matchesClimbed,
      required this.trapAverage,
      required this.yStddevGamepiecePoints,
      required this.gamepiecesStddev});
  final double gamepiecesStddev;
  final double yStddevGamepiecePoints;
  final LightTeam team;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
  final double autoGamepieceAvg;
  final double teleGamepieceAvg;
  final double gamepieceAvg;
  final double missedAvg;
  final double gamepiecePointAvg;
  final double trapAverage;
  final int brokenMatches;
  final int amountOfMatches;
  final int matchesClimbed;
}

import "package:scouting_frontend/models/team_model.dart";

class AllTeamData {
  AllTeamData({
    required this.faultMessages,
    required this.taken,
    required this.thirdPickListIndex,
    required this.team,
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
  });
  final LightTeam team;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
  final int thirdPickListIndex;
  final double autoGamepieceAvg;
  final double teleGamepieceAvg;
  final double gamepieceAvg;
  final double missedAvg;
  final double gamepiecePointAvg;
  final double trapAverage;
  final int brokenMatches;
  final int amountOfMatches;
  final int matchesClimbed;
  bool taken;
  final List<String> faultMessages;
}

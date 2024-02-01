import "package:scouting_frontend/models/team_model.dart";

class AllTeamData {
  AllTeamData({
    required this.climbedPercentage,
    required this.teleAmpAvg,
    required this.teleSpeakerAvg,
    required this.workedPercentage,
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
  int firstPicklistIndex;
  int secondPicklistIndex;
  int thirdPickListIndex;
  final double autoGamepieceAvg;
  final double teleGamepieceAvg;
  final double teleAmpAvg;
  final double teleSpeakerAvg;
  final double gamepieceAvg;
  final double missedAvg;
  final double gamepiecePointAvg;
  final double trapAverage;
  final int brokenMatches;
  final int amountOfMatches;
  final int matchesClimbed;
  final double workedPercentage;
  final double climbedPercentage;
  bool taken;
  final List<String> faultMessages;

  @override
  String toString() => "${team.name}  ${team.number}";
}

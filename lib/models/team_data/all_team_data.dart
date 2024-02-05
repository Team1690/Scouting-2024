import "package:scouting_frontend/models/team_model.dart";
import 'package:scouting_frontend/models/team_data/aggregate_data/aggregate_technical_data.dart';

class AllTeamData {
  //TODO: make const + add copywith
  AllTeamData({
    required this.climbedPercentage,
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
    required this.gamepiecePointAvg,
    required this.brokenMatches,
    required this.amountOfMatches,
    required this.matchesClimbed,
    required this.aggregateData,
  });
  final LightTeam team;
  int firstPicklistIndex;
  int secondPicklistIndex;
  int thirdPickListIndex;
  final double autoGamepieceAvg;
  final double teleGamepieceAvg;
  final double gamepieceAvg;
  final double gamepiecePointAvg;
  final int brokenMatches;
  final int amountOfMatches;
  final int matchesClimbed;
  final double workedPercentage;
  final double climbedPercentage;
  bool taken;
  final AggregateData aggregateData;
  final List<String> faultMessages;

  @override
  String toString() => "${team.name}  ${team.number}";
}

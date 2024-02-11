import "package:scouting_frontend/models/team_data/technical_data.dart";

class QuickData {
  QuickData({
    required this.medianData,
    required this.avgData,
    required this.maxData,
    required this.minData,
    required this.amoutOfMatches,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
    required this.thirdPicklistIndex,
    required this.matchesClimbedSingle,
    required this.matchesClimbedDouble,
    required this.matchesClimbedTriple,
    required this.climbPercentage,
    required this.canHarmony,
    required this.gamepiecePoints,
    required this.gamepiecesScored,
    required this.trapAmount,
    required this.avgGamepiecesNoDefense,
    required this.avgGamepiecesHalfDefense,
    required this.avgGamepiecesFullDefense,
    required this.trapSuccessRate,
  });
  final int amoutOfMatches;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
  final int thirdPicklistIndex;
  final TechnicalData<double> medianData;
  final TechnicalData<double> avgData;
  final TechnicalData<int> maxData;
  final TechnicalData<int> minData;
  final int matchesClimbedSingle;
  final int matchesClimbedDouble;
  final int matchesClimbedTriple;
  final double climbPercentage;
  final bool? canHarmony;
  final double gamepiecePoints;
  final double gamepiecesScored;
  final int? trapAmount;
  final double avgGamepiecesNoDefense;
  final double avgGamepiecesHalfDefense;
  final double avgGamepiecesFullDefense;
  final double trapSuccessRate;
}

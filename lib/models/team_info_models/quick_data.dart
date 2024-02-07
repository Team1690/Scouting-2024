class QuickData {
  QuickData({
    required this.amoutOfMatches,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
    required this.thirdPicklistIndex,
    required this.autoAmpAvg,
    required this.teleAmpAvg,
    required this.bestAmpGamepiecesSum,
    required this.autoSpeakerAvg,
    required this.teleSpeakerAvg,
    required this.bestSpeakerGamepiecesSum,
    required this.matchesClimbedSingle,
    required this.matchesClimbedDouble,
    required this.matchesClimbedTriple,
    required this.climbPercentage,
    required this.canHarmony,
    required this.gamepiecePoints,
    required this.gamepiecesScored,
    required this.avgAutoSpeakerMissed,
    required this.avgTeleSpeakerMissed,
    required this.avgTrapAmount,
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
  final double autoAmpAvg;
  final double teleAmpAvg;
  final int bestAmpGamepiecesSum;
  final double autoSpeakerAvg;
  final double teleSpeakerAvg;
  final int bestSpeakerGamepiecesSum;
  final int matchesClimbedSingle;
  final int matchesClimbedDouble;
  final int matchesClimbedTriple;
  final double climbPercentage;
  final bool? canHarmony;
  final double gamepiecePoints;
  final double gamepiecesScored;
  final double avgAutoSpeakerMissed;
  final double avgTeleSpeakerMissed;
  final double avgTrapAmount;
  final int? trapAmount;
  final double avgGamepiecesNoDefense;
  final double avgGamepiecesHalfDefense;
  final double avgGamepiecesFullDefense;
  final double trapSuccessRate;
}

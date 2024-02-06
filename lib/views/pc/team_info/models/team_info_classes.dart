import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/models/team_data/specific_match_data.dart";
import "package:scouting_frontend/models/team_data/pit_data/pit_data.dart";

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

class AutoByPosData {
  AutoByPosData({
    required this.amoutOfMatches,
  });
  final int amoutOfMatches;
}

class AutoData {
  //TODO rename these to season specific names
  AutoData({
    required this.slot3Data,
    required this.slot2Data,
    required this.slot1Data,
  });
  final AutoByPosData slot1Data;
  final AutoByPosData slot2Data;
  final AutoByPosData slot3Data;
}

class SpecificData {
  const SpecificData(this.msg);
  final List<SpecificMatchData> msg;
}

class LineChartData {
  LineChartData({
    required this.points,
    required this.title,
    required this.gameNumbers,
    required this.robotMatchStatuses,
    required this.defenseAmounts,
  });
  final List<List<int>> points;
  final List<List<RobotFieldStatus>> robotMatchStatuses;
  final List<List<DefenseAmount>> defenseAmounts;
  final List<MatchIdentifier> gameNumbers;
  final String title;
}

enum RobotFieldStatus { worked, didntComeToField, didntWorkOnField }

enum DefenseAmount { noDefense, halfDefense, fullDefense }

class Team {
  Team({
    required this.team,
    required this.specificData,
    required this.pitViewData,
    required this.quickData,
    required this.autoData,
  });
  //TODO add season specific charts and data
  final LightTeam team;
  final SpecificData specificData;
  final PitData? pitViewData;
  final QuickData quickData;
  final AutoData autoData;
}

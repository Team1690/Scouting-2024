import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_match_data.dart";

import '../../../common/fetch_functions/pit_data/pit_data.dart';

class QuickData {
  QuickData({
    //TODO add season specific variables
    required this.amoutOfMatches,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
  });
  final int amoutOfMatches;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
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
  final List<List<RobotMatchStatus>> robotMatchStatuses;
  final List<List<DefenseAmount>> defenseAmounts;
  final List<MatchIdentifier> gameNumbers;
  final String title;
}

enum RobotMatchStatus { worked, didntComeToField, didntWorkOnField }

enum DefenseAmount { noDefense, halfDefense, fullDefense }

class MatchIdentifier {
  const MatchIdentifier({
    required this.number,
    required this.type,
    required this.isRematch,
  });
  final String type;
  final int number;
  final bool isRematch;

  @override
  bool operator ==(final Object other) =>
      other is MatchIdentifier &&
      other.type == type &&
      other.number == number &&
      other.isRematch == isRematch;

  @override
  int get hashCode => Object.hash(type, number, isRematch);

  @override
  String toString() => "${isRematch ? "R" : ""}${shortenType(type)}$number";

  static String shortenType(final String matchType) {
    switch (matchType) {
      case "Pre scouting":
        return "pre";
      case "Practice":
        return "pra";
      case "Quals":
        return "";
      case "Finals":
        return "f";
      case "Semi finals":
        return "sf";
      case "Quarter finals":
        return "qf";
      case "Round robin":
        return "rb";
      case "Einstein finals":
        return "ef";
      case "Double elims":
        return "de";
    }
    throw Exception("Not a supported match type");
  }
}

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

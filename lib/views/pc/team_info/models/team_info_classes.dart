import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/models/team_data/specific_match_data.dart";
import "package:scouting_frontend/models/team_data/pit_data/pit_data.dart";

import '../../../../models/enums/defense_amount_enum.dart';
import '../../../../models/enums/robot_field_status.dart';

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

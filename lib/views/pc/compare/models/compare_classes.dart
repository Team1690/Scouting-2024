import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class CompareTeam {
  CompareTeam({
    required this.avgAutoGamepiecePoints,
    required this.avgTeleGamepiecesPoints,
    required this.teleGamepieces,
    required this.gamepieces,
    required this.gamepiecePoints,
    required this.team,
    required this.autoGamepieces,
    required this.totalSpeakers,
    required this.totalAmps,
    required this.totalDelivered,
    required this.climbed,
  });
  final LightTeam team;
  final double avgTeleGamepiecesPoints;
  final double avgAutoGamepiecePoints;
  final CompareLineChartData autoGamepieces;
  final CompareLineChartData teleGamepieces;
  final CompareLineChartData gamepieces;
  final CompareLineChartData gamepiecePoints;
  final CompareLineChartData totalSpeakers;
  final CompareLineChartData totalAmps;
  final CompareLineChartData totalDelivered;
  final CompareLineChartData climbed;
}

class CompareLineChartData {
  CompareLineChartData({
    required this.points,
    required this.matchStatuses,
    required this.defenseAmounts,
  });
  final List<int> points;
  final List<RobotMatchStatus> matchStatuses;
  final List<DefenseAmount> defenseAmounts;
}

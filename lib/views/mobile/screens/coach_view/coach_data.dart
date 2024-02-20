import "package:scouting_frontend/models/schedule_match.dart";

class CoachData {
  CoachData({
    required this.match,
    required this.avgBlueWithFourth,
    required this.avgRedWithFourth,
    required this.avgBlue,
    required this.avgRed,
  });

  final ScheduleMatch match;
  final double avgBlueWithFourth;
  final double avgRedWithFourth;
  final double avgBlue;
  final double avgRed;
}

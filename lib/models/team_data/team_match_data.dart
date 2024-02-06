import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_data/specific_match_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";

class MatchData {
  MatchData({
    required this.technicalMatchData,
    required this.specificMatchData,
    required this.scheduleMatch,
  });

  final TechnicalMatchData? technicalMatchData;
  final SpecificMatchData? specificMatchData;
  final ScheduleMatch scheduleMatch;
}

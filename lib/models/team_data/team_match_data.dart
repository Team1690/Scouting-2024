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

extension MatchDataList on List<MatchData> {
  List<MatchData> get fullGames => where(
        (final MatchData element) =>
            element.technicalMatchData != null &&
            element.specificMatchData != null,
      ).toList();
  List<MatchData> get technicalMatchExists =>
      where((final MatchData element) => element.technicalMatchData != null)
          .toList();
  List<MatchData> get specificMatches =>
      where((final MatchData element) => element.specificMatchData != null)
          .toList();
}

import "package:collection/collection.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/team_data/specific_match_data.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/models/team_data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/team_data/specific_summary_data.dart";
import "package:scouting_frontend/models/team_data/pit_data/pit_data.dart";
import "package:scouting_frontend/views/mobile/screens/fault_entry.dart";

class TeamData {
  TeamData({
    required this.matches,
    required this.pitData,
    required this.lightTeam,
    required this.faultEntrys,
    required this.aggregateData,
    required this.summaryData,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
    required this.thirdPicklistIndex,
  });
  final List<FaultEntry> faultEntrys;
  final AggregateData aggregateData;
  final PitData? pitData;
  final SpecificSummaryData? summaryData;
  final LightTeam lightTeam;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
  final int thirdPicklistIndex;
  final List<MatchData> matches;

  List<TechnicalMatchData> get technicalMatches => matches
      .map((final MatchData e) => e.technicalMatchData)
      .whereNotNull()
      .toList();
  List<SpecificMatchData> get specificMatches => matches
      .map((final MatchData e) => e.specificMatchData)
      .whereNotNull()
      .toList();

  int get matchesClimbedSingle => technicalMatches
      .where(
        (final TechnicalMatchData element) =>
            (element.climb == Climb.climbed ||
                element.climb == Climb.buddyClimbed) &&
            element.harmonyWith == 0,
      )
      .length;
  int get matchesClimbedDouble => technicalMatches
      .where(
        (final TechnicalMatchData element) =>
            (element.climb == Climb.climbed ||
                element.climb == Climb.buddyClimbed) &&
            element.harmonyWith == 1,
      )
      .length;
  int get matchesClimbedTriple => technicalMatches
      .where(
        (final TechnicalMatchData element) =>
            (element.climb == Climb.climbed ||
                element.climb == Climb.buddyClimbed) &&
            element.harmonyWith == 2,
      )
      .length;

  int get matchesClimbed => technicalMatches
      .where(
        (final TechnicalMatchData element) => (element.climb == Climb.climbed ||
            element.climb == Climb.buddyClimbed),
      )
      .length;

  double get climbPercentage =>
      100 *
      (aggregateData.gamesPlayed == 0
          ? 0
          : matchesClimbed / (aggregateData.gamesPlayed));

  double get aim =>
      100 *
      (aggregateData.avgData.gamepieces /
              (aggregateData.avgData.gamepieces +
                  aggregateData.avgData.totalMissed))
          .clamp(double.minPositive, double.maxFinite);

  double get trapSuccessRate =>
      100 * aggregateData.sumData.trapAmount / aggregateData.gamesPlayed;
}

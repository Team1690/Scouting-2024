import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/data/pit_data/pit_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/models/data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";

class AllTeamData {
  AllTeamData({
    required this.pitData,
    required this.technicalMatches,
    required this.team,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
    required this.thirdPickListIndex,
    required this.taken,
    required this.aggregateData,
    required this.faultMessages,
  });

  //TODO: make const + add copywith
  final LightTeam team;
  int firstPicklistIndex;
  int secondPicklistIndex;
  int thirdPickListIndex;
  bool taken;
  final AggregateData aggregateData;
  final PitData? pitData;
  final List<TechnicalMatchData> technicalMatches;
  final List<String> faultMessages;

  int get brokenMatches => technicalMatches
      .where(
        (final TechnicalMatchData match) =>
            match.robotFieldStatus != RobotFieldStatus.worked,
      )
      .length;

  double get workedPercentage => aggregateData.gamesPlayed == 0
      ? double.negativeInfinity
      : 100 *
          (technicalMatches
                  .where(
                    (final TechnicalMatchData match) =>
                        match.robotFieldStatus == RobotFieldStatus.worked,
                  )
                  .length /
              aggregateData.gamesPlayed);
  int get matchesClimbed => technicalMatches
      .where(
        (final TechnicalMatchData element) =>
            element.climb == Climb.climbed ||
            element.climb == Climb.buddyClimbed,
      )
      .length;
  double get climbPercentage =>
      100 *
      (aggregateData.gamesPlayed == 0
          ? double.negativeInfinity
          : (matchesClimbed / aggregateData.gamesPlayed));
  double get aim => aggregateData.gamesPlayed == 0
      ? double.negativeInfinity
      : 100 *
          (aggregateData.avgData.gamepieces /
                  (aggregateData.avgData.gamepieces +
                      aggregateData.avgData.totalMissed))
              .clamp(0, 1);
  bool get harmony => technicalMatches
      .where((final TechnicalMatchData element) => element.harmonyWith != 0)
      .isNotEmpty;
  @override
  String toString() => "${team.name}  ${team.number}";
}

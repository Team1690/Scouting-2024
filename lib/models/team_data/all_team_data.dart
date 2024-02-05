import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/models/team_data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class AllTeamData {
  AllTeamData({
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
  final List<TechnicalMatchData> technicalMatches;
  final List<String> faultMessages;

  int get brokenMatches => technicalMatches
      .where(
        (final TechnicalMatchData match) =>
            match.robotFieldStatus != RobotFieldStatus.worked,
      )
      .length;

  double get workedPercentage =>
      100 *
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
  double get climbPercentage => aggregateData.gamesPlayed == 0
      ? 0
      : matchesClimbed / aggregateData.gamesPlayed;
  @override
  String toString() => "${team.name}  ${team.number}";
}

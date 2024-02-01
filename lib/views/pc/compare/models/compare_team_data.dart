import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_match_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class CompareTeamData {
  CompareTeamData({
    required this.avgAutoGamepiecePoints,
    required this.avgTeleGamepiecesPoints,
    required this.teleGamepieces,
    required this.gamepieces,
    required this.gamepiecePoints,
    required this.team,
    required this.autoGamepieces,
    required this.totalAmps,
    required this.totalSpeakers,
    required this.totalMissed,
    required this.climbed,
  });
  final LightTeam team;
  final double avgTeleGamepiecesPoints;
  final double avgAutoGamepiecePoints;
  final CompareLineChartData autoGamepieces;
  final CompareLineChartData teleGamepieces;
  final CompareLineChartData gamepieces;
  final CompareLineChartData gamepiecePoints;
  final CompareLineChartData totalAmps;
  final CompareLineChartData totalSpeakers;
  final CompareLineChartData totalMissed;
  final CompareLineChartData climbed;

  static CompareTeamData parse(final TeamData data) => CompareTeamData(
        avgAutoGamepiecePoints:
            data.aggregateData.avgAutoAmp + data.aggregateData.avgAutoSpeaker,
        avgTeleGamepiecesPoints:
            data.aggregateData.avgTeleAmp + data.aggregateData.avgTeleSpeaker,
        teleGamepieces: CompareLineChartData(
          points: data.technicalMatches
              .map(
                (final TechnicalMatchData match) =>
                    match.teleAmp + match.teleSpeaker,
              )
              .toList(),
          matchStatuses: data.technicalMatches
              .map((final TechnicalMatchData match) => match.robotFieldStatus)
              .toList(),
          defenseAmounts: data.specificMatches
              .map((final SpecificMatchData match) => match.defenseAmount)
              .toList(),
        ),
        gamepieces: CompareLineChartData(
          points: data.technicalMatches
              .map((final TechnicalMatchData e) => e.gamepieces)
              .toList(),
          matchStatuses: data.technicalMatches
              .map((final TechnicalMatchData match) => match.robotFieldStatus)
              .toList(),
          defenseAmounts: data.specificMatches
              .map((final SpecificMatchData match) => match.defenseAmount)
              .toList(),
        ),
        gamepiecePoints: CompareLineChartData(
          points: data.technicalMatches
              .map(
                (final TechnicalMatchData match) => match.gamepiecePoints,
              )
              .toList(),
          matchStatuses: data.technicalMatches
              .map((final TechnicalMatchData match) => match.robotFieldStatus)
              .toList(),
          defenseAmounts: data.specificMatches
              .map((final SpecificMatchData match) => match.defenseAmount)
              .toList(),
        ),
        team: data.lightTeam,
        autoGamepieces: CompareLineChartData(
          points: data.technicalMatches
              .map(
                (final TechnicalMatchData match) =>
                    match.autoAmp + match.autoSpeaker,
              )
              .toList(),
          matchStatuses: data.technicalMatches
              .map((final TechnicalMatchData match) => match.robotFieldStatus)
              .toList(),
          defenseAmounts: data.specificMatches
              .map((final SpecificMatchData match) => match.defenseAmount)
              .toList(),
        totalAmps: CompareLineChartData(points: points, matchStatuses: matchStatuses, defenseAmounts: defenseAmounts),
        totalSpeakers: totalSpeakers,
        totalMissed: totalMissed,
        climbed: climbed,
      );
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

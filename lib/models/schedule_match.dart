import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";

class ScheduleMatch {
  ScheduleMatch({
    required this.matchIdentifier,
    required this.happened,
    required this.id,
    required this.redAlliance,
    required this.blueAlliance,
  });

  final MatchIdentifier matchIdentifier;
  final bool happened;
  final int id;
  final List<LightTeam> redAlliance;
  final List<LightTeam> blueAlliance;

  String? getTeamStation(final LightTeam team) {
    String? fieldPositionOf(
      final List<LightTeam> alliance,
      final String color,
    ) {
      final int index = alliance.indexOf(team);
      return index == -1
          ? null
          : "${team.number} ${team.name} - $color ${index + 1}";
    }

    return fieldPositionOf(redAlliance, "red") ??
        fieldPositionOf(blueAlliance, "blue");
  }
}

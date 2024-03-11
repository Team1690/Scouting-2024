import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/fetch_matches.dart";

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

  static ScheduleMatch fromJson(
    final dynamic e,
    final bool isRematch,
    final IdTable<MatchType> matchType,
  ) =>
      ScheduleMatch(
        happened: e["happened"] as bool,
        id: e["id"] as int,
        matchIdentifier: MatchIdentifier.fromJson(
          <String, dynamic>{
            "schedule_match": e,
          },
          matchType,
          isRematch,
        ),
        redAlliance: <LightTeam>[...alliancefromJson(e, "red")],
        blueAlliance: <LightTeam>[...alliancefromJson(e, "blue")],
      );

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

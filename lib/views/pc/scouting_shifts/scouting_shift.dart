import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";

class ScoutingShift {
  ScoutingShift({
    required this.name,
    required this.matchIdentifier,
    required this.team,
    required this.scheduleId,
  });

  final String name;
  final MatchIdentifier matchIdentifier;
  final LightTeam team;
  final int scheduleId;

  static ScoutingShift fromJson(
    final dynamic shift,
    final IdProvider provider,
  ) =>
      ScoutingShift(
        name: shift["scouter_name"] as String,
        matchIdentifier: MatchIdentifier.fromJson(
          shift,
          provider.matchType,
          false,
        ),
        team: LightTeam.fromJson(shift["team"]),
        scheduleId: shift["schedule_match"]["id"] as int,
      );
}

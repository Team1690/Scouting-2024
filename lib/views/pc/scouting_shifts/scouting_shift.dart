import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";

class ScoutingShift {
  const ScoutingShift({
    required this.name,
    required this.matchIdentifier,
    required this.team,
  });

  final String name;
  final MatchIdentifier matchIdentifier;
  final LightTeam team;

  static ScoutingShift fromJson(
    final dynamic shift,
    final IdProvider provider,
  ) =>
      ScoutingShift(
        name: shift["name"] as String,
        matchIdentifier: MatchIdentifier.fromJson(
          shift,
          provider.matchType,
          false,
        ),
        team: LightTeam.fromJson(shift["team"]),
      );
}

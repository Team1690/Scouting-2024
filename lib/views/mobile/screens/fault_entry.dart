import "package:scouting_frontend/models/team_model.dart";

class FaultEntry {
  const FaultEntry({
    required this.faultMessage,
    required this.team,
    required this.id,
    required this.faultStatus,
    required this.matchNumber,
    required this.matchType,
  });
  final int? matchType;
  final int? matchNumber;
  final String faultMessage;
  final int id;
  final LightTeam team;
  final String faultStatus;

  static FaultEntry parse(final dynamic fault) => FaultEntry(
        faultMessage: fault["message"] as String,
        team: LightTeam(
          fault["team"]["id"] as int,
          fault["team"]["number"] as int,
          fault["team"]["name"] as String,
          fault["team"]["colors_index"] as int,
        ),
        id: fault["id"] as int,
        faultStatus: fault["fault_status"]["title"] as String,
        matchNumber: fault["match_number"] as int?,
        matchType: fault["match_type"]["order"] as int?,
      );
}

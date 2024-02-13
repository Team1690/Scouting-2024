import "package:scouting_frontend/models/enums/match_type_enum.dart";
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
  final MatchType matchType;
  final int? matchNumber;
  final String faultMessage;
  final int id;
  final LightTeam team;
  final String faultStatus;

  static FaultEntry parse(final dynamic fault) => FaultEntry(
        faultMessage: fault["message"] as String,
        team: LightTeam.fromJson(fault["team"]),
        id: fault["id"] as int,
        faultStatus: fault["fault_status"]["title"] as String,
        matchNumber: fault["match_number"] as int?,
        matchType: matchTypeTitleToEnum(fault["match_type"]["title"] as String),
      );
}

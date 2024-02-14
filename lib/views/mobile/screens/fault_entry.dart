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
    required this.isRematch,
  });
  final MatchType matchType;
  final int? matchNumber;
  final String faultMessage;
  final int id;
  final LightTeam team;
  final String faultStatus;
  final bool isRematch;

  static FaultEntry parse(final dynamic fault) => FaultEntry(
        isRematch: fault["is_rematch"] as bool,
        faultMessage: fault["message"] as String,
        team: LightTeam.fromJson(fault["team"]),
        id: fault["id"] as int,
        faultStatus: fault["fault_status"]["title"] as String,
        matchNumber: fault["schedule_match"]["match_number"] as int?,
        matchType: matchTypeTitleToEnum(
          fault["schedule_match"]["match_type"]["title"] as String,
        ),
      );
}

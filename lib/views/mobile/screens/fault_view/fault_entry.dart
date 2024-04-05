import "package:scouting_frontend/models/enums/fault_status_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";

class FaultEntry {
  const FaultEntry({
    required this.faultMessage,
    required this.team,
    required this.id,
    required this.faultStatus,
    required this.matchIdentifier,
  });
  final MatchIdentifier matchIdentifier;
  final String faultMessage;
  final int id;
  final LightTeam team;
  final FaultStatus faultStatus;

  static FaultEntry parse(final dynamic fault, final IdProvider idProvider) =>
      FaultEntry(
        matchIdentifier: MatchIdentifier.fromJson(fault, idProvider.matchType),
        faultMessage: fault["message"] as String,
        team: LightTeam.fromJson(fault["team"]),
        id: fault["id"] as int,
        faultStatus: idProvider
            .faultStatus.idToEnum[fault["fault_status"]["id"] as int]!,
      );
}

import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/fetch_matches.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

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

  bool get isUnofficial =>
      matchIdentifier.type == MatchType.practice ||
      matchIdentifier.type == MatchType.pre;

  String getTeamStation(
          final LightTeam team, final List<ScoutingShift> shifts) =>
      "${team.number} ${team.name} - ${shifts.firstWhere(
            (final ScoutingShift element) =>
                element.matchIdentifier.number == matchIdentifier.number &&
                element.matchIdentifier.type == matchIdentifier.type &&
                element.team == team,
            orElse: () => ScoutingShift(
              name: "",
              matchIdentifier: matchIdentifier,
              team: team,
              scheduleId: id,
            ),
          ).name}";
}

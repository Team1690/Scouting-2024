import "package:scouting_frontend/views/pc/status/status_light_team.dart";

class StatusMatch {
  const StatusMatch({required this.scouter, required this.scoutedTeam});
  final StatusLightTeam scoutedTeam;
  final String scouter;
}

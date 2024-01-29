import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class TeamData {
  TeamData({
    required this.avgAutoSpeakerMissed,
    required this.avgTeleSpeakerMissed,
    required this.avgTeleAmpMissed,
    required this.technicalMatches,
    required this.avgAutoAmpMissed,
    required this.avgTeleSpeaker,
    required this.avgAutoSpeaker,
    required this.defenseAmount,
    required this.avgTrapAmount,
    required this.avgAutoAmp,
    required this.avgTeleAmp,
    required this.pitData,
    required this.lightTeam,
    required this.faultEntry,
  });
  final List<TechnicalMatch> technicalMatches;
  final DefenseAmount defenseAmount;
  final double avgAutoSpeakerMissed;
  final double avgTeleSpeakerMissed;
  final double avgTeleAmpMissed;
  final double avgAutoAmpMissed;
  final List<FaultEntry> faultEntry;
  final double avgTeleSpeaker;
  final double avgAutoSpeaker;
  final double avgTrapAmount;
  final double avgAutoAmp;
  final double avgTeleAmp;
  final PitData pitData;
  final LightTeam lightTeam;
}

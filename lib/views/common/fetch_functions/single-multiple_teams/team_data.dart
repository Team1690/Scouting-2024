import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";
import "package:scouting_frontend/views/common/fetch_functions/pit_data/pit_data.dart";

class TeamData {
  TeamData({
    required this.avgAutoSpeakerMissed,
    required this.avgTeleSpeakerMissed,
    required this.avgTeleAmpMissed,
    required this.technicalMatches,
    required this.avgAutoAmpMissed,
    required this.avgTeleSpeaker,
    required this.avgAutoSpeaker,
    required this.avgTrapAmount,
    required this.avgAutoAmp,
    required this.avgTeleAmp,
    required this.pitData,
    required this.lightTeam,
    required this.faultEntrys,
    required this.specificMatches,
  });
  final List<TechnicalMatchData> technicalMatches;
  final List<SpecificMatch> specificMatches;
  final double avgAutoSpeakerMissed;
  final double avgTeleSpeakerMissed;
  final double avgTeleAmpMissed;
  final double avgAutoAmpMissed;
  final List<FaultEntry> faultEntrys;
  final double avgTeleSpeaker;
  final double avgAutoSpeaker;
  final double avgTrapAmount;
  final double avgAutoAmp;
  final double avgTeleAmp;
  final PitData pitData;
  final LightTeam lightTeam;
}

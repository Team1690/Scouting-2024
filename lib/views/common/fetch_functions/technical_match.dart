import "package:scouting_frontend/views/common/fetch_functions/climb_enum.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class TechnicalMatch {
  TechnicalMatch({
    required this.teleSpeakerMissed,
    required this.autoSpeakerMissed,
    required this.robotMatchStatus,
    required this.climbingPoints,
    required this.teleAmpMissed,
    required this.autoAmpMissed,
    required this.teleSpeaker,
    required this.autoSpeaker,
    required this.matchNumber,
    required this.harmonyWith,
    required this.trapAmount,
    required this.autoAmp,
    required this.teleAmp,
    required this.climb,
  });
  final RobotMatchStatus robotMatchStatus;
  final int autoSpeakerMissed;
  final int teleSpeakerMissed;
  final int climbingPoints;
  final int teleAmpMissed;
  final int autoAmpMissed;
  final int teleSpeaker;
  final int autoSpeaker;
  final int matchNumber;
  final int harmonyWith;
  final int trapAmount;
  final int autoAmp;
  final int teleAmp;
  final Climb climb;
}

import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/views/common/fetch_functions/climb_enum.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class TechnicalMatch {
  TechnicalMatch({
    required this.teleSpeakerMissed,
    required this.autoSpeakerMissed,
    required this.robotFieldStatus,
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

  final RobotMatchStatus robotFieldStatus;
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

  static TechnicalMatch parse(final dynamic match) => TechnicalMatch(
        teleSpeakerMissed: match["tele_speaker_missed"] as int,
        autoSpeakerMissed: match["auto_speaker_missed"] as int,
        robotFieldStatus: robotMatchStatusTitleToEnum(
          match["robot_field_status"]["title"] as String,
        ),
        climbingPoints: match["climb"]["points"] as int,
        teleAmpMissed: match["tele_amp_missed"] as int,
        autoAmpMissed: match["auto_amp_missed"] as int,
        teleSpeaker: match["tele_speaker"] as int,
        autoSpeaker: match["auto_speaker"] as int,
        matchNumber: match["number"] as int,
        harmonyWith: match["harmony_with"] as int,
        trapAmount: match["trap_amount"] as int,
        autoAmp: match["auto_amp"] as int,
        teleAmp: match["tele_amp"] as int,
        climb: climbTitleToEnum(match["climb"]["title"] as String),
      );
}

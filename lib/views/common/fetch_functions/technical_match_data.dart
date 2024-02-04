import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/views/common/fetch_functions/climb_enum.dart";
import "package:scouting_frontend/views/common/fetch_functions/parse_match_functions.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class TechnicalMatchData {
  TechnicalMatchData({
    required this.trapsMissed,
    required this.gamepiecesPoints,
    required this.teleSpeakerMissed,
    required this.autoSpeakerMissed,
    required this.robotFieldStatus,
    required this.climbingPoints,
    required this.autoGamepieces,
    required this.teleGamepieces,
    required this.teleAmpMissed,
    required this.autoAmpMissed,
    required this.teleSpeaker,
    required this.autoSpeaker,
    required this.matchNumber,
    required this.harmonyWith,
    required this.trapAmount,
    required this.gamepieces,
    required this.autoAmp,
    required this.teleAmp,
    required this.climb,
    required this.scheduleMatchId,
  });

  final RobotFieldStatus robotFieldStatus;
  final int teleSpeakerMissed;
  final int autoSpeakerMissed;
  final int gamepiecesPoints;
  final int teleGamepieces;
  final int autoGamepieces;
  final int climbingPoints;
  final int teleAmpMissed;
  final int autoAmpMissed;
  final int teleSpeaker;
  final int autoSpeaker;
  final int matchNumber;
  final int harmonyWith;
  final int trapsMissed;
  final int trapAmount;
  final int gamepieces;
  final int teleAmp;
  final int autoAmp;
  final Climb climb;
  final int scheduleMatchId;

  static TechnicalMatchData parse(final dynamic match) => TechnicalMatchData(
        teleSpeakerMissed: match["tele_speaker_missed"] as int,
        autoSpeakerMissed: match["auto_speaker_missed"] as int,
        robotFieldStatus: robotFieldStatusTitleToEnum(
          match["robot_field_status"]["title"] as String,
        ),
        climbingPoints: match["climb"]["points"] as int,
        teleAmpMissed: match["tele_amp_missed"] as int,
        autoAmpMissed: match["auto_amp_missed"] as int,
        teleSpeaker: match["tele_speaker"] as int,
        autoSpeaker: match["auto_speaker"] as int,
        matchNumber: match["schedule_match"]["match_number"] as int,
        harmonyWith: match["harmony_with"] as int,
        trapsMissed: match["traps_missed"] as int,
        trapAmount: match["trap_amount"] as int,
        autoAmp: match["auto_amp"] as int,
        teleAmp: match["tele_amp"] as int,
        climb: climbTitleToEnum(match["climb"]["title"] as String),
        gamepiecesPoints: getPoints(parseMatch(match)),
        autoGamepieces: getPieces(parseByMode(MatchMode.auto, match)),
        teleGamepieces: getPieces(parseByMode(MatchMode.tele, match)),
        gamepieces: getPieces(parseMatch(match)),
        scheduleMatchId: match["schedule_match"]["id"] as int,
      );
}

import "package:scouting_frontend/models/enums/point_giver_enum.dart";

class TechnicalData {
  TechnicalData({
    required this.autoSpeakerMissed,
    required this.teleSpeakerMissed,
    required this.teleAmpMissed,
    required this.autoAmpMissed,
    required this.teleSpeaker,
    required this.autoSpeaker,
    required this.trapAmount,
    required this.trapsMissed,
    required this.autoAmp,
    required this.teleAmp,
  });

  final num autoSpeakerMissed;
  final num teleSpeakerMissed;
  final num teleAmpMissed;
  final num autoAmpMissed;
  final num teleSpeaker;
  final num autoSpeaker;
  final num trapAmount;
  final num trapsMissed;
  final num autoAmp;
  final num teleAmp;

  num get ampGamepieces => teleAmp + autoAmp;
  num get speakerGamepieces => teleSpeaker + autoSpeaker;
  num get autoGamepieces => autoAmp + autoSpeaker;
  num get teleGamepieces => teleAmp + teleSpeaker;
  num get gamepieces => autoGamepieces + teleGamepieces;
  num get totalMissed =>
      teleAmpMissed + autoAmpMissed + teleSpeakerMissed + autoSpeakerMissed;
  num get autoSpeakerPoints => PointGiver.autoSpeaker.points * autoSpeaker;
  num get autoAmpPoints => PointGiver.autoAmp.points * autoAmp;
  num get teleSpeakerPoints => PointGiver.teleSpeaker.points * teleSpeaker;
  num get teleAmpPoints => PointGiver.teleAmp.points * teleAmp;
  num get autoPoints => autoAmpPoints + autoSpeakerPoints;
  num get telePoints => teleSpeakerPoints + teleAmpPoints;
  num get ampPoints => autoAmpPoints + teleAmpPoints;
  num get speakerPoints => autoSpeakerPoints + teleSpeakerPoints;
  num get gamePiecesPoints => autoPoints + telePoints;

  static TechnicalData parse(final dynamic table) => TechnicalData(
        autoSpeakerMissed: table["auto_speaker_missed"] as num? ?? 0,
        teleSpeakerMissed: table["tele_speaker_missed"] as num? ?? 0,
        teleAmpMissed: table["tele_amp_missed"] as num? ?? 0,
        autoAmpMissed: table["auto_amp_missed"] as num? ?? 0,
        teleSpeaker: table["tele_speaker"] as num? ?? 0,
        autoSpeaker: table["auto_speaker"] as num? ?? 0,
        autoAmp: table["auto_amp"] as num? ?? 0,
        teleAmp: table["tele_amp"] as num? ?? 0,
        trapAmount: table["trap_amount"] as num? ?? 0,
        trapsMissed: table["traps_missed"] as num? ?? 0,
      );
}

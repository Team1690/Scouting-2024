import "package:scouting_frontend/models/enums/point_giver_enum.dart";

class TechnicalData<T extends num> {
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
    required this.climbingPoints,
  });

  final T autoSpeakerMissed;
  final T teleSpeakerMissed;
  final T teleAmpMissed;
  final T autoAmpMissed;
  final T teleSpeaker;
  final T autoSpeaker;
  final T trapAmount;
  final T trapsMissed;
  final T autoAmp;
  final T teleAmp;
  final T climbingPoints;

  T get ampGamepieces => teleAmp + autoAmp as T;
  T get speakerGamepieces => teleSpeaker + autoSpeaker as T;
  T get autoGamepieces => autoAmp + autoSpeaker as T;
  T get teleGamepieces => teleAmp + teleSpeaker as T;
  T get gamepieces => autoGamepieces + teleGamepieces as T;
  T get totalMissed =>
      teleAmpMissed + autoAmpMissed + teleSpeakerMissed + autoSpeakerMissed
          as T;
  T get autoSpeakerPoints => PointGiver.autoSpeaker.points * autoSpeaker as T;
  T get autoAmpPoints => PointGiver.autoAmp.points * autoAmp as T;
  T get teleSpeakerPoints => PointGiver.teleSpeaker.points * teleSpeaker as T;
  T get teleAmpPoints => PointGiver.teleAmp.points * teleAmp as T;
  T get autoPoints => autoAmpPoints + autoSpeakerPoints as T;
  T get telePoints => teleSpeakerPoints + teleAmpPoints as T;
  T get ampPoints => autoAmpPoints + teleAmpPoints as T;
  T get speakerPoints => autoSpeakerPoints + teleSpeakerPoints as T;
  T get gamePiecesPoints => autoPoints + telePoints as T;

  static TechnicalData<T> parse<T extends num>(final dynamic table) =>
      TechnicalData<T>(
        autoSpeakerMissed:
            (table["auto_speaker_missed"] as num? ?? 0).numericCast(),
        teleSpeakerMissed:
            (table["tele_speaker_missed"] as num? ?? 0).numericCast(),
        teleAmpMissed: (table["tele_amp_missed"] as num? ?? 0).numericCast(),
        autoAmpMissed: (table["auto_amp_missed"] as num? ?? 0).numericCast(),
        teleSpeaker: (table["tele_speaker"] as num? ?? 0).numericCast(),
        autoSpeaker: (table["auto_speaker"] as num? ?? 0).numericCast(),
        autoAmp: (table["auto_amp"] as num? ?? 0).numericCast(),
        teleAmp: (table["tele_amp"] as num? ?? 0).numericCast(),
        trapAmount: (table["trap_amount"] as num? ?? 0).numericCast(),
        trapsMissed: (table["traps_missed"] as num? ?? 0).numericCast(),
        climbingPoints: (table["climb"]["points"] as num? ?? 0).numericCast(),
      );
}

//TODO: util folder
extension NumericExtension on num {
  T numericCast<T extends num>() {
    if (T == double) {
      return toDouble() as T;
    } else if (T == int) {
      return toInt() as T;
    } else {
      throw Exception("Invalid num implmenetor");
    }
  }
}

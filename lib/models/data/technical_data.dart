import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/models/enums/point_giver_enum.dart";

class TechnicalData<T extends num> {
  TechnicalData({
    required this.autoSpeakerMissed,
    required this.teleSpeakerMissed,
    required this.teleAmpMissed,
    required this.teleSpeaker,
    required this.autoSpeaker,
    required this.trapAmount,
    required this.trapsMissed,
    required this.teleAmp,
    required this.climbingPoints,
    required this.delivery,
  });

  final T autoSpeakerMissed;
  final T teleSpeakerMissed;
  final T teleAmpMissed;
  final T teleSpeaker;
  final T autoSpeaker;
  final T trapAmount;
  final T trapsMissed;
  final T teleAmp;
  final T climbingPoints;
  final T delivery;

  T get ampGamepieces => teleAmp;
  T get speakerGamepieces => teleSpeaker + autoSpeaker as T;
  T get autoGamepieces => autoSpeaker;
  T get teleGamepieces => teleAmp + teleSpeaker as T;
  T get gamepieces => autoGamepieces + teleGamepieces as T;
  T get missedAuto => autoSpeakerMissed;
  T get missedTele => teleAmpMissed + teleSpeakerMissed as T;
  T get missedAmp => teleAmpMissed;
  T get missedSpeaker => autoSpeakerMissed + autoSpeakerMissed as T;
  T get totalMissed => missedAuto + missedTele as T;

  T get autoSpeakerPoints => PointGiver.autoSpeaker.points * autoSpeaker as T;
  T get teleSpeakerPoints => PointGiver.teleSpeaker.points * teleSpeaker as T;
  T get teleAmpPoints => PointGiver.teleAmp.points * teleAmp as T;
  T get autoPoints => autoSpeakerPoints;
  T get telePoints => teleSpeakerPoints + teleAmpPoints as T;
  T get ampPoints => teleAmpPoints;
  T get speakerPoints => autoSpeakerPoints + teleSpeakerPoints as T;
  T get gamePiecesPoints => autoPoints + telePoints as T;

  static TechnicalData<T> parse<T extends num>(
    final dynamic table,
    final List<(AutoGamepieceID, AutoGamepieceState)> autoGamepieces,
  ) =>
      TechnicalData<T>(
        teleSpeakerMissed:
            (table["tele_speaker_missed"] as num? ?? 0).numericCast(),
        teleAmpMissed: (table["tele_amp_missed"] as num? ?? 0).numericCast(),
        teleSpeaker: (table["tele_speaker"] as num? ?? 0).numericCast(),
        autoSpeaker: autoGamepieces
            .where(
              (final (AutoGamepieceID, AutoGamepieceState) state) =>
                  state.$2 == AutoGamepieceState.scoredSpeaker,
            )
            .length
            .numericCast(),
        // (table["auto_speaker"] as num? ?? 0).numericCast(),
        autoSpeakerMissed: autoGamepieces
            .where(
              (final (AutoGamepieceID, AutoGamepieceState) state) =>
                  state.$2 == AutoGamepieceState.missedSpeaker,
            )
            .length
            .numericCast(),
        //(table["auto_speaker_missed"] as num? ?? 0).numericCast(),
        teleAmp: (table["tele_amp"] as num? ?? 0).numericCast(),
        trapAmount: (table["trap_amount"] as num? ?? 0).numericCast(),
        trapsMissed: (table["traps_missed"] as num? ?? 0).numericCast(),
        climbingPoints: (table["climb"]["points"] as num? ?? 0).numericCast(),
        delivery: (table["delivery"] as num? ?? 0).numericCast(),
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

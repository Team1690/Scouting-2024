class MinData {
  MinData({
    required this.minAutoSpeakerMissed,
    required this.minTeleSpeakerMissed,
    required this.minTeleAmpMissed,
    required this.minAutoAmpMissed,
    required this.minTeleSpeaker,
    required this.minAutoSpeaker,
    required this.minTrapAmount,
    required this.minAutoAmp,
    required this.minTeleAmp,
  });
  final int minAutoSpeakerMissed;
  final int minTeleSpeakerMissed;
  final int minTeleAmpMissed;
  final int minAutoAmpMissed;
  final int minTeleSpeaker;
  final int minAutoSpeaker;
  final int minTrapAmount;
  final int minAutoAmp;
  final int minTeleAmp;

  static MinData parse(
    final dynamic minTable,
  ) =>
      MinData(
        minAutoSpeakerMissed: minTable["auto_speaker_missed"] as int? ?? 0,
        minTeleSpeakerMissed: minTable["tele_speaker_missed"] as int? ?? 0,
        minTeleAmpMissed: minTable["tele_amp_missed"] as int? ?? 0,
        minAutoAmpMissed: minTable["auto_amp_missed"] as int? ?? 0,
        minTeleSpeaker: minTable["tele_speaker"] as int? ?? 0,
        minAutoSpeaker: minTable["auto_speaker"] as int? ?? 0,
        minAutoAmp: minTable["auto_amp"] as int? ?? 0,
        minTeleAmp: minTable["tele_amp"] as int? ?? 0,
        minTrapAmount: minTable["trap_amount"] as int? ?? 0,
      );
}

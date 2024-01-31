class MaxData {
  MaxData({
    required this.maxAutoSpeakerMissed,
    required this.maxTeleSpeakerMissed,
    required this.maxTeleAmpMissed,
    required this.maxAutoAmpMissed,
    required this.maxTeleSpeaker,
    required this.maxAutoSpeaker,
    required this.maxTrapAmount,
    required this.maxAutoAmp,
    required this.maxTeleAmp,
  });
  final int maxAutoSpeakerMissed;
  final int maxTeleSpeakerMissed;
  final int maxTeleAmpMissed;
  final int maxAutoAmpMissed;
  final int maxTeleSpeaker;
  final int maxAutoSpeaker;
  final int maxTrapAmount;
  final int maxAutoAmp;
  final int maxTeleAmp;

  static MaxData parse(
    final dynamic avgTable,
  ) =>
      MaxData(
        maxAutoSpeakerMissed: avgTable["auto_speaker_missed"] as int? ?? 0,
        maxTeleSpeakerMissed: avgTable["tele_speaker_missed"] as int? ?? 0,
        maxTeleAmpMissed: avgTable["tele_amp_missed"] as int? ?? 0,
        maxAutoAmpMissed: avgTable["auto_amp_missed"] as int? ?? 0,
        maxTeleSpeaker: avgTable["tele_speaker"] as int? ?? 0,
        maxAutoSpeaker: avgTable["auto_speaker"] as int? ?? 0,
        maxAutoAmp: avgTable["auto_amp"] as int? ?? 0,
        maxTeleAmp: avgTable["tele_amp"] as int? ?? 0,
        maxTrapAmount: avgTable["trap_amount"] as int? ?? 0,
      );
}

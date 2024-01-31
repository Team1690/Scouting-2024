class AvgData {
  AvgData({
    required this.avgAutoSpeakerMissed,
    required this.avgTeleSpeakerMissed,
    required this.avgTeleAmpMissed,
    required this.avgAutoAmpMissed,
    required this.avgTeleSpeaker,
    required this.avgAutoSpeaker,
    required this.avgTrapAmount,
    required this.avgAutoAmp,
    required this.avgTeleAmp,
  });
  final double avgAutoSpeakerMissed;
  final double avgTeleSpeakerMissed;
  final double avgTeleAmpMissed;
  final double avgAutoAmpMissed;
  final double avgTeleSpeaker;
  final double avgAutoSpeaker;
  final double avgTrapAmount;
  final double avgAutoAmp;
  final double avgTeleAmp;

  static AvgData parse(
    final dynamic avgTable,
  ) =>
      AvgData(
        avgAutoSpeakerMissed: avgTable["auto_speaker_missed"] as double? ?? 0,
        avgTeleSpeakerMissed: avgTable["tele_speaker_missed"] as double? ?? 0,
        avgTeleAmpMissed: avgTable["tele_amp_missed"] as double? ?? 0,
        avgAutoAmpMissed: avgTable["auto_amp_missed"] as double? ?? 0,
        avgTeleSpeaker: avgTable["tele_speaker"] as double? ?? 0,
        avgAutoSpeaker: avgTable["auto_speaker"] as double? ?? 0,
        avgAutoAmp: avgTable["auto_amp"] as double? ?? 0,
        avgTeleAmp: avgTable["tele_amp"] as double? ?? 0,
        avgTrapAmount: avgTable["trap_amount"] as double? ?? 0,
      );
}

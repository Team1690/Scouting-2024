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

  final double autoSpeakerMissed;
  final double teleSpeakerMissed;
  final double teleAmpMissed;
  final double autoAmpMissed;
  final double teleSpeaker;
  final double autoSpeaker;
  final double trapAmount;
  final double trapsMissed;
  final double autoAmp;
  final double teleAmp;

  static TechnicalData parse(final dynamic table) => TechnicalData(
        autoSpeakerMissed: table["auto_speaker_missed"] as double? ?? 0,
        teleSpeakerMissed: table["tele_speaker_missed"] as double? ?? 0,
        teleAmpMissed: table["tele_amp_missed"] as double? ?? 0,
        autoAmpMissed: table["auto_amp_missed"] as double? ?? 0,
        teleSpeaker: table["tele_speaker"] as double? ?? 0,
        autoSpeaker: table["auto_speaker"] as double? ?? 0,
        autoAmp: table["auto_amp"] as double? ?? 0,
        teleAmp: table["tele_amp"] as double? ?? 0,
        trapAmount: table["trap_amount"] as double? ?? 0,
        trapsMissed: table["traps_missed"] as double? ?? 0,
      );
}

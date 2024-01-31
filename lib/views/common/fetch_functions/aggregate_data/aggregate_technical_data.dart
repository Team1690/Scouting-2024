class AggregateData {
  AggregateData({
    required this.avgAutoSpeakerMissed,
    required this.avgTeleSpeakerMissed,
    required this.avgTeleAmpMissed,
    required this.avgAutoAmpMissed,
    required this.avgTeleSpeaker,
    required this.avgAutoSpeaker,
    required this.avgTrapAmount,
    required this.avgAutoAmp,
    required this.avgTeleAmp,
    required this.maxAutoSpeakerMissed,
    required this.maxTeleSpeakerMissed,
    required this.maxTeleAmpMissed,
    required this.maxAutoAmpMissed,
    required this.maxTeleSpeaker,
    required this.maxAutoSpeaker,
    required this.maxTrapAmount,
    required this.maxAutoAmp,
    required this.maxTeleAmp,
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
  final double avgAutoSpeakerMissed;
  final double avgTeleSpeakerMissed;
  final double avgTeleAmpMissed;
  final double avgAutoAmpMissed;
  final double avgTeleSpeaker;
  final double avgAutoSpeaker;
  final double avgTrapAmount;
  final double avgAutoAmp;
  final double avgTeleAmp;
  final int maxAutoSpeakerMissed;
  final int maxTeleSpeakerMissed;
  final int maxTeleAmpMissed;
  final int maxAutoAmpMissed;
  final int maxTeleSpeaker;
  final int maxAutoSpeaker;
  final int maxTrapAmount;
  final int maxAutoAmp;
  final int maxTeleAmp;
  final int minAutoSpeakerMissed;
  final int minTeleSpeakerMissed;
  final int minTeleAmpMissed;
  final int minAutoAmpMissed;
  final int minTeleSpeaker;
  final int minAutoSpeaker;
  final int minTrapAmount;
  final int minAutoAmp;
  final int minTeleAmp;

  static AggregateData parse(final dynamic aggregateTable) => AggregateData(
        avgAutoSpeakerMissed:
            aggregateTable["auto_speaker_missed"] as double? ?? 0,
        avgTeleSpeakerMissed:
            aggregateTable["tele_speaker_missed"] as double? ?? 0,
        avgTeleAmpMissed: aggregateTable["tele_amp_missed"] as double? ?? 0,
        avgAutoAmpMissed: aggregateTable["auto_amp_missed"] as double? ?? 0,
        avgTeleSpeaker: aggregateTable["tele_speaker"] as double? ?? 0,
        avgAutoSpeaker: aggregateTable["auto_speaker"] as double? ?? 0,
        avgAutoAmp: aggregateTable["auto_amp"] as double? ?? 0,
        avgTeleAmp: aggregateTable["tele_amp"] as double? ?? 0,
        avgTrapAmount: aggregateTable["trap_amount"] as double? ?? 0,
        maxAutoSpeakerMissed:
            aggregateTable["auto_speaker_missed"] as int? ?? 0,
        maxTeleSpeakerMissed:
            aggregateTable["tele_speaker_missed"] as int? ?? 0,
        maxTeleAmpMissed: aggregateTable["tele_amp_missed"] as int? ?? 0,
        maxAutoAmpMissed: aggregateTable["auto_amp_missed"] as int? ?? 0,
        maxTeleSpeaker: aggregateTable["tele_speaker"] as int? ?? 0,
        maxAutoSpeaker: aggregateTable["auto_speaker"] as int? ?? 0,
        maxAutoAmp: aggregateTable["auto_amp"] as int? ?? 0,
        maxTeleAmp: aggregateTable["tele_amp"] as int? ?? 0,
        maxTrapAmount: aggregateTable["trap_amount"] as int? ?? 0,
        minAutoSpeakerMissed:
            aggregateTable["auto_speaker_missed"] as int? ?? 0,
        minTeleSpeakerMissed:
            aggregateTable["tele_speaker_missed"] as int? ?? 0,
        minTeleAmpMissed: aggregateTable["tele_amp_missed"] as int? ?? 0,
        minAutoAmpMissed: aggregateTable["auto_amp_missed"] as int? ?? 0,
        minTeleSpeaker: aggregateTable["tele_speaker"] as int? ?? 0,
        minAutoSpeaker: aggregateTable["auto_speaker"] as int? ?? 0,
        minAutoAmp: aggregateTable["auto_amp"] as int? ?? 0,
        minTeleAmp: aggregateTable["tele_amp"] as int? ?? 0,
        minTrapAmount: aggregateTable["trap_amount"] as int? ?? 0,
      );
}

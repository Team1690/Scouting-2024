class AggregateData {
  AggregateData({
    required this.avgAutoSpeakerMissed,
    required this.avgTeleSpeakerMissed,
    required this.avgTeleAmpMissed,
    required this.avgAutoAmpMissed,
    required this.avgTeleSpeaker,
    required this.avgAutoSpeaker,
    required this.avgTrapAmount,
    required this.avgTrapsMissed,
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
  final double avgTrapsMissed;
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
            aggregateTable["avg"]["auto_speaker_missed"] as double? ?? 0,
        avgTeleSpeakerMissed:
            aggregateTable["avg"]["tele_speaker_missed"] as double? ?? 0,
        avgTeleAmpMissed:
            aggregateTable["avg"]["tele_amp_missed"] as double? ?? 0,
        avgAutoAmpMissed:
            aggregateTable["avg"]["auto_amp_missed"] as double? ?? 0,
        avgTeleSpeaker: aggregateTable["avg"]["tele_speaker"] as double? ?? 0,
        avgAutoSpeaker: aggregateTable["avg"]["auto_speaker"] as double? ?? 0,
        avgAutoAmp: aggregateTable["avg"]["auto_amp"] as double? ?? 0,
        avgTeleAmp: aggregateTable["avg"]["tele_amp"] as double? ?? 0,
        avgTrapAmount: aggregateTable["avg"]["trap_amount"] as double? ?? 0,
        avgTrapsMissed: aggregateTable["avg"]["traps_missed"] as double? ?? 0,
        maxAutoSpeakerMissed:
            aggregateTable["max"]["auto_speaker_missed"] as int? ?? 0,
        maxTeleSpeakerMissed:
            aggregateTable["max"]["tele_speaker_missed"] as int? ?? 0,
        maxTeleAmpMissed: aggregateTable["max"]["tele_amp_missed"] as int? ?? 0,
        maxAutoAmpMissed: aggregateTable["max"]["auto_amp_missed"] as int? ?? 0,
        maxTeleSpeaker: aggregateTable["max"]["tele_speaker"] as int? ?? 0,
        maxAutoSpeaker: aggregateTable["max"]["auto_speaker"] as int? ?? 0,
        maxAutoAmp: aggregateTable["max"]["auto_amp"] as int? ?? 0,
        maxTeleAmp: aggregateTable["max"]["tele_amp"] as int? ?? 0,
        maxTrapAmount: aggregateTable["max"]["trap_amount"] as int? ?? 0,
        minAutoSpeakerMissed:
            aggregateTable["min"]["auto_speaker_missed"] as int? ?? 0,
        minTeleSpeakerMissed:
            aggregateTable["min"]["tele_speaker_missed"] as int? ?? 0,
        minTeleAmpMissed: aggregateTable["min"]["tele_amp_missed"] as int? ?? 0,
        minAutoAmpMissed: aggregateTable["min"]["auto_amp_missed"] as int? ?? 0,
        minTeleSpeaker: aggregateTable["min"]["tele_speaker"] as int? ?? 0,
        minAutoSpeaker: aggregateTable["min"]["auto_speaker"] as int? ?? 0,
        minAutoAmp: aggregateTable["min"]["auto_amp"] as int? ?? 0,
        minTeleAmp: aggregateTable["min"]["tele_amp"] as int? ?? 0,
        minTrapAmount: aggregateTable["min"]["trap_amount"] as int? ?? 0,
      );
}

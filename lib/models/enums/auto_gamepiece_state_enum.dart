enum AutoGamepieceState {
  scoredSpeaker("Scored Speaker"),
  missedSpeaker("Missed Speaker"),
  scoredAmp("Scored Amp"),
  missedAmp("Missed Amp"),
  notTaken("Not Taken");

  const AutoGamepieceState(this.title);

  final String title;
}

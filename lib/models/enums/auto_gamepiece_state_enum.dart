import "package:scouting_frontend/models/id_providers.dart";

enum AutoGamepieceState implements IdEnum {
  scoredSpeaker("Scored Speaker"),
  missedSpeaker("Missed Speaker"),
  scoredAmp("Scored Amp"),
  missedAmp("Missed Amp"),
  notTaken("Not Taken");

  const AutoGamepieceState(this.title);

  @override
  final String title;
}

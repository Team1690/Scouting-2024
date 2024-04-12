import "package:scouting_frontend/models/providers/id_providers.dart";

enum AutonomousOptions implements IdEnum {
  onlyClose("Only Close"),
  onlyMiddle("Only Middle Amp Side"),
  closeAndMiddle("Close And Middle"),
  feederSide("Only Middle Feeder Side"),
  other("Other");

  const AutonomousOptions(this.title);

  @override
  final String title;
}

import "package:scouting_frontend/models/providers/id_providers.dart";

enum AutonomousOptions implements IdEnum {
  onlyClose("Only Close"),
  onlyMiddle("Only Middle"),
  closeAndMiddle("Close And Middle");

  const AutonomousOptions(this.title);

  @override
  final String title;
}

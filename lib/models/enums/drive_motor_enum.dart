import "package:scouting_frontend/models/id_providers.dart";

enum DriveMotor implements IdEnum {
  falcon("Falcon"),
  neo("NEO"),
  neoVortex("Neo Vortex"),
  cim("CIM"),
  miniCIM("Mini CIM"),
  kraken("Kraken"),
  other("Other");

  const DriveMotor(this.title);
  @override
  final String title;
}

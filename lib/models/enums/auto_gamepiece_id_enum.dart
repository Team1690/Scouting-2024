import "package:scouting_frontend/models/providers/id_providers.dart";

enum AutoGamepieceID implements IdEnum {
  zero("R0"),
  one("L0"),
  two("L1"),
  three("L2"),
  four("M0"),
  five("M1"),
  six("M2"),
  seven("M3"),
  eight("M4");

  const AutoGamepieceID(this.title);

  @override
  final String title;

  AutoGamepieceID fromString(final String id) =>
      values.firstWhere((final AutoGamepieceID e) => e.title == id);
}

import "package:scouting_frontend/models/id_providers.dart";

enum StartingPosition implements IdEnum {
  amp("Amp"),
  center("Center"),
  source("Source");

  const StartingPosition(this.title);
  @override
  final String title;
}

import "package:scouting_frontend/models/id_providers.dart";

enum ShootingRange implements IdEnum {
  closeRange("Close Range Shooting"),
  allRanges("All Range Shooting");

  const ShootingRange(this.title);
  @override
  final String title;
}

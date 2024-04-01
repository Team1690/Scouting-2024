import "package:scouting_frontend/models/id_providers.dart";

enum ShootingRange implements IdEnum {
  subwoofer("Subwoofer"),
  freeRange("Free Range");

  const ShootingRange(this.title);
  @override
  final String title;
}

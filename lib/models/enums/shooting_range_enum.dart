import "package:scouting_frontend/models/id_providers.dart";

enum ShootingRange implements IdEnum {
  closeRange("Close Range Shooting"),
  allRanges("All Range Shooting");

  const ShootingRange(this.title);
  @override
  final String title;
}

ShootingRange climbTitleToEnum(final String title) =>
    ShootingRange.values
        .where((final ShootingRange rangeOption) => rangeOption.title == title)
        .singleOrNull ??
    (throw Exception("Invalid title: $title"));

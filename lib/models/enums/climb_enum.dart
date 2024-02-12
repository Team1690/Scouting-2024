enum Climb {
  noAttempt("No Attempt", 0, 0),
  failed("Failed", 1, 0),
  climbed("Climbed", 2, 3),
  buddyClimbed("Buddy Climbed", 3, 6);

  const Climb(this.title, this.chartHeight, this.points);
  final String title;
  final double chartHeight;
  final int points;
}

Climb climbTitleToEnum(final String title) =>
    Climb.values
        .where((final Climb climbOption) => climbOption.title == title)
        .singleOrNull ??
    (throw Exception("Invalid title: $title"));

Climb climbPointsToEnum(final int points) =>
    Climb.values
        .where((final Climb climbPoints) => climbPoints.points == points)
        .singleOrNull ??
    (throw Exception("Invalid points: $points"));

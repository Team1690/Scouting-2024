enum Climb {
  noAttempt("No Attempt", 0),
  failed("Failed", 1),
  climbed("Climbed", 2),
  buddyClimbed("Buddy Climbed", 3);

  const Climb(this.title, this.chartHeight);
  final String title;
  final int chartHeight;
}

Climb climbTitleToEnum(final String title) =>
    Climb.values
        .where((final Climb climbOption) => climbOption.title == title)
        .singleOrNull ??
    (throw Exception("Invalid title: $title"));

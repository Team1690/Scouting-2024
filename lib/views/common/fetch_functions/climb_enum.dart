enum Climb {
  noAttempt("No Attempt"),
  failed("Failed"),
  climbed("Climbed"),
  buddyClimbed("Buddy Climbed");

  const Climb(this.title);
  final String title;
}

Climb climbTitleToEnum(final String title) =>
    Climb.values
        .where((final Climb climbOption) => climbOption.title == title)
        .singleOrNull ??
    (throw Exception("Invalid title: $title"));

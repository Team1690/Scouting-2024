enum Climb {
  noAttempt("No Attempt"),
  failed("Failed"),
  climbed("Climbed"),
  buddyClimbed("Buddy Climbed");

  const Climb(final String title);
}

Climb climbTitleToEnum(final String title) {
  switch (title) {
    case "No Attempt":
      return Climb.noAttempt;
    case "Failed":
      return Climb.failed;
    case "Climbed":
      return Climb.climbed;
    case "Buddy Climbed":
      return Climb.buddyClimbed;
  }
  throw Exception("Isn't a valid title");
}

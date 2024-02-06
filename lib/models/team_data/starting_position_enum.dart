enum StartingPosition {
  amp("Amp"),
  center("Center"),
  source("Source");

  const StartingPosition(this.title);
  final String title;
}

StartingPosition startingPosTitleToEnum(final String title) =>
    StartingPosition.values
        .where(
          (final StartingPosition startingPos) => startingPos.title == title,
        )
        .singleOrNull ??
    (throw Exception("Invalid title: $title"));

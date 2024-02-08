enum DefenseAmount {
  noDefense("No Defense"),
  halfDefense("Half Defense"),
  fullDefense("Full Defense");

  const DefenseAmount(this.title);
  final String title;
}

DefenseAmount defenseAmountTitleToEnum(final String title) =>
    DefenseAmount.values
        .where((final DefenseAmount defense) => defense.title == title)
        .singleOrNull ??
    (throw Exception("Isn't a Valid Defense Title"));

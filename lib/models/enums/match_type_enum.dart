enum MatchType {
  pre("Pre Scouting", 0),
  practice("Practice", 1),
  quals("Quals", 2),
  finals("Finals", 4),
  einsteinfinals("Einstein Finals", 5),
  doubleElim("Double Elims", 3);

  const MatchType(this.title, this.order);
  final String title;
  final int order;

  String get shortTitle => title.substring(0, 1);
}

MatchType matchTypeTitleToEnum(final String title) =>
    MatchType.values
        .where((final MatchType element) => element.title == title)
        .singleOrNull ??
    (throw Exception("Not A Valid Match Type Title"));

enum MatchType {
  pre("Pre Scouting"),
  practice("Practice"),
  quals("Quals"),
  finals("Finals"),
  einsteinfinals("Einstein Finals"),
  doubleElim("Double Elims");

  const MatchType(this.title);
  final String title;
}

MatchType matchTypeTitleToEnum(final String title) =>
    MatchType.values
        .where((final MatchType element) => element.title == title)
        .singleOrNull ??
    (throw Exception("Not A Valid Match Type Title"));

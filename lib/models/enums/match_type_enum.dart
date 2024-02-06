enum MatchType {
  pre("Pre Scouting"),
  practice("Practice"),
  quals("Quals"),
  quarterfinals("Quarter Finals"),
  semifinals("Semi Finals"),
  finals("Finals"),
  roundrobin("Round Robin"),
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

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

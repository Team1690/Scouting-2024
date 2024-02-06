enum MatchMode {
  auto(1, "auto"),
  tele(0, "tele");

  const MatchMode(this.pointAddition, this.title);
  final int pointAddition;
  final String title;
}

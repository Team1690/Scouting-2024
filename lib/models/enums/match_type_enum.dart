import "package:scouting_frontend/models/providers/id_providers.dart";

enum MatchType implements IdEnum {
  pre("Pre Scouting", 0),
  practice("Practice", 1),
  quals("Quals", 2),
  finals("Finals", 4),
  einsteinfinals("Einstein Finals", 5),
  doubleElim("Double Elims", 3);

  const MatchType(this.title, this.order);
  @override
  final String title;
  final int order;

  String get shortTitle => title.substring(0, 1);
}

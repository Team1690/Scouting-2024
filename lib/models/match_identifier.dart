import "package:scouting_frontend/models/enums/match_type_enum.dart";

class MatchIdentifier {
  MatchIdentifier({
    required this.type,
    required this.number,
    required this.isRematch,
  });

  final MatchType type;
  final int number;
  final bool isRematch;

  @override
  String toString() => "${isRematch ? "R" : ""}${type.title}$number";
}

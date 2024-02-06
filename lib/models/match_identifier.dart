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

  static MatchIdentifier fromJson(final dynamic scheduleMatch) =>
      MatchIdentifier(
        type: matchTypeTitleToEnum(
          scheduleMatch["match_type"]["title"] as String,
        ),
        number: scheduleMatch["number"] as int,
        isRematch: scheduleMatch["is_rematch"] as bool,
      );
}

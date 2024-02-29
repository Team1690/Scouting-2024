import "package:scouting_frontend/models/enums/match_type_enum.dart";

class MatchIdentifier {
  MatchIdentifier({
    required this.type,
    required this.number,
    required this.isRematch,
  });

  final MatchType type;
  final int number;
  late final bool isRematch;

  @override
  bool operator ==(final Object other) =>
      other is MatchIdentifier &&
      other.isRematch == isRematch &&
      other.number == number &&
      other.type == type;

  @override
  int get hashCode => Object.hashAll(<Object?>[isRematch, number, type]);

  @override
  String toString() => "${isRematch ? "R" : ""}${type.shortTitle}$number";

  static MatchIdentifier fromJson(
    final dynamic match, [
    final bool? isRematch,
  ]) =>
      MatchIdentifier(
        type: matchTypeTitleToEnum(
          match["schedule_match"]["match_type"]["title"] as String,
        ),
        number: match["schedule_match"]["match_number"] as int,
        isRematch: isRematch ?? match["is_rematch"] as bool,
      );
}

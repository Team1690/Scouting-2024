import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";

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
    final dynamic match,
    final IdTable<MatchType> matchType, [
    final bool? isRematch,
  ]) =>
      MatchIdentifier(
        type: matchType
            .idToEnum[match["schedule_match"]["match_type"]["id"] as int]!,
        number: match["schedule_match"]["match_number"] as int,
        isRematch: isRematch ?? match["is_rematch"] as bool,
      );

  int compareTo(MatchIdentifier other) {
    final int cmp = type.order.compareTo(other.type.order);
    if (cmp != 0) return cmp;
    return number.compareTo(other.number);
  }
}

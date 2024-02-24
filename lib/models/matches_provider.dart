import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";

class MatchesProvider extends InheritedWidget {
  MatchesProvider({
    required super.child,
    required this.matches,
  });
  final List<ScheduleMatch> matches;
  @override
  bool updateShouldNotify(final MatchesProvider oldWidget) =>
      matches != oldWidget.matches;

  static MatchesProvider of(final BuildContext context) {
    final MatchesProvider? result =
        context.dependOnInheritedWidgetOfExactType<MatchesProvider>();
    assert(result != null, "No ScheduleMatches found in context");
    return result!;
  }

  static List<ScheduleMatch> matchesWith1690(final BuildContext context) =>
      MatchesProvider.of(context)
          .matches
          .where(
            (final ScheduleMatch match) =>
                (match.redAlliance
                        .any((final LightTeam team) => team.number == 1690) ||
                    match.blueAlliance
                        .any((final LightTeam team) => team.number == 1690)) &&
                match.matchIdentifier.isRematch != false,
          )
          .toList();
  static List<LightTeam> teamsWith1690(final BuildContext context) =>
      matchesWith1690(context)
          .map(
            (final ScheduleMatch e) =>
                <LightTeam>[...e.blueAlliance, ...e.redAlliance],
          )
          .flattened
          .toList();
}

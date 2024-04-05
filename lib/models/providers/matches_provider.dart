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
  bool updateShouldNotify(covariant final MatchesProvider oldWidget) =>
      matches != oldWidget.matches;

  static MatchesProvider of(final BuildContext context) {
    final MatchesProvider? result =
        context.dependOnInheritedWidgetOfExactType<MatchesProvider>();
    assert(result != null, "No ScheduleMatches found in context");
    return result!;
  }

  static List<ScheduleMatch> matchesWith(
    final int teamNumber,
    final BuildContext context,
  ) =>
      MatchesProvider.of(context)
          .matches
          .where(
            (final ScheduleMatch match) =>
                (match.redAlliance.any(
                      (final LightTeam team) => team.number == teamNumber,
                    ) ||
                    match.blueAlliance.any(
                      (final LightTeam team) => team.number == teamNumber,
                    )) &&
                match.matchIdentifier.isRematch != false,
          )
          .toList();
  static List<LightTeam> teamsWith(
    final int teamNumber,
    final BuildContext context,
  ) =>
      matchesWith(teamNumber, context)
          .map(
            (final ScheduleMatch e) =>
                <LightTeam>[...e.blueAlliance, ...e.redAlliance],
          )
          .flattened
          .toList();
}

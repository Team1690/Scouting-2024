import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_model.dart";

class TeamProvider extends InheritedWidget {
  TeamProvider({
    required final Widget child,
    required final List<LightTeam> teams,
  }) : this._inner(
          child: child,
          numberToTeam: Map<int, LightTeam>.unmodifiable(
            <int, LightTeam>{for (final LightTeam e in teams) e.number: e},
          ),
        );
  const TeamProvider._inner({
    required super.child,
    required this.numberToTeam,
  });
  final Map<int, LightTeam> numberToTeam;
  List<LightTeam> get teams => numberToTeam.values.toList();
  @override
  bool updateShouldNotify(final TeamProvider oldWidget) =>
      numberToTeam != oldWidget.numberToTeam || teams != oldWidget.teams;

  static TeamProvider of(final BuildContext context) {
    final TeamProvider? result =
        context.dependOnInheritedWidgetOfExactType<TeamProvider>();
    assert(result != null, "No Teams found in context");
    return result!;
  }
}

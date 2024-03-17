import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";

class HarmonyWith extends StatelessWidget {
  const HarmonyWith({super.key, required this.match, required this.onNewMatch});
  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;
  @override
  Widget build(final BuildContext context) => Slider(
        thumbColor: Colors.blue[400],
        activeColor: Colors.blue[400],
        value: match.harmonyWith.toDouble(),
        max: 2,
        divisions: 2,
        label: match.harmonyWith.toString(),
        onChanged: (final double harmonyWith) {
          onNewMatch(match.copyWith(harmonyWith: always(harmonyWith.toInt())));
        },
      );
}

class ClimbingSelector extends StatelessWidget {
  const ClimbingSelector({required this.match, required this.onNewMatch});
  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;
  @override
  Widget build(final BuildContext context) => Selector<Climb>(
        options: Climb.values,
        placeholder: "Select climing status",
        value: match.climb,
        makeItem: (final Climb climb) => climb.title,
        onChange: (final Climb id) {
          onNewMatch(
            match.copyWith(
              climb: always(id),
              harmonyWith: always(0),
            ),
          );
        },
        validate: always2(null),
      );
}

class Climbing extends StatelessWidget {
  const Climbing({required this.match, required this.onNewMatch});
  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;
  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          ClimbingSelector(match: match, onNewMatch: onNewMatch),
          if (match.climb == Climb.climbed)
            HarmonyWith(match: match, onNewMatch: onNewMatch),
        ],
      );
}

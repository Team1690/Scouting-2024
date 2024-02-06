import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/input_view_vars.dart";

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
  Widget build(final BuildContext context) => Selector<int>(
        options: IdProvider.of(context).climb.idToName.keys.toList(),
        placeholder: "Select climing status",
        value: match.climbId,
        makeItem: (final int id) => IdProvider.of(context).climb.idToName[id]!,
        onChange: (final int id) {
          onNewMatch(
            match.copyWith(
              climbId: always(id),
              harmonyWith: always(
                IdProvider.of(context).climb.idToName[id] == "Buddy Climbed"
                    ? 1
                    : 0,
              ),
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
          if (IdProvider.of(context).climb.idToName[match.climbId] ==
                  "Climbed" ||
              IdProvider.of(context).climb.idToName[match.climbId] ==
                  "Buddy Climbed")
            HarmonyWith(match: match, onNewMatch: onNewMatch),
        ],
      );
}

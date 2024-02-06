import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/input_view_vars.dart";

class StartingPos extends StatelessWidget {
  const StartingPos({required this.match, required this.onNewMatch});
  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;
  @override
  Widget build(final BuildContext context) => Selector<int>(
        options:
            IdProvider.of(context).startingPosition.nameToId.values.toList(),
        placeholder: "Select starting position",
        value: match.startingPositionID,
        makeItem: (final int id) =>
            IdProvider.of(context).startingPosition.idToName[id]!,
        onChange: (final int id) {
          onNewMatch(match.copyWith(startingPositionID: always(id)));
        },
        validate: always2(null),
      );
}

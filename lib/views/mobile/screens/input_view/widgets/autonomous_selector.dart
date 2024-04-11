import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/autonomous_options_enum.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";

class AutonomousSelector extends StatelessWidget {
  const AutonomousSelector({required this.match, required this.onNewMatch});
  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;
  @override
  Widget build(final BuildContext context) => Selector<AutonomousOptions>(
        options: AutonomousOptions.values,
        placeholder: "Select Autonomous Type",
        value: match.autonomousOptions,
        makeItem: (final AutonomousOptions autoOption) => autoOption.title,
        onChange: (final AutonomousOptions autoOption) {
          onNewMatch(
            match.copyWith(
              autonomousOptions: always(autoOption),
            ),
          );
        },
        validate: always2(null),
      );
}

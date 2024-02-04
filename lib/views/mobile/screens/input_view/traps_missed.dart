import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/models/match_model.dart";

class TrapsMissed extends StatelessWidget {
  const TrapsMissed({
    required this.onTrapChange,
    required this.flickerScreen,
    required this.match,
  });

  final Match match;
  final void Function(int trap) onTrapChange;
  final void Function(int newValue, int oldValue) flickerScreen;

  @override
  Widget build(final BuildContext context) => Counter(
        upperLimit: 3,
        label: "Traps missed",
        icon: Icons.compress,
        onChange: (final int trap) {
          flickerScreen(trap, match.trapAmount);
          onTrapChange(trap);
        },
        count: match.trapsMissed,
      );
}

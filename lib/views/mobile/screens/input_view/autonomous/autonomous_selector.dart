import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/autonomous/auto_gamepieces.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/autonomous/autonomous_gamepiece_card.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";

class AutonomousSelector extends StatelessWidget {
  const AutonomousSelector({
    super.key,
    required this.match,
    required this.onNewMatch,
    this.isRedAlliance = false,
  });

  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;
  final bool isRedAlliance;

  @override
  Widget build(final BuildContext context) {
    final Map<AutoGamepieceID, AutoGamepieceState> gamepieces =
        match.autoGamepieces.asMap;
    final List<Widget> buttonColumns = List<Widget>.generate(
      3,
      (final int index) => Expanded(
        child: Column(
          children: gamepieces.keys
              .where(
                (final AutoGamepieceID element) =>
                    element.title.startsWith("R") && index == 0 ||
                    (element.title.startsWith("L") && index == 1) ||
                    (element.title.startsWith("M") && index == 2),
              )
              .map(
                (final AutoGamepieceID gamepieceId) => AutonomousGamepiece(
                  color: getColorByState(
                    gamepieces[gamepieceId] ?? AutoGamepieceState.noAttempt,
                    isRedAlliance,
                  ),
                  state: gamepieces[gamepieceId]!,
                  gamepieceID: gamepieceId,
                  onSelectedStateOfGamepiece: (final AutoGamepieceState state) {
                    gamepieces[gamepieceId] = state;
                    InputViewVars newMatch = match.copyWith(
                      autoGamepieces: () => AutoGamepieces.fromMap(gamepieces),
                    );
                    if (!newMatch.autoOrder.contains(gamepieceId) &&
                        state != AutoGamepieceState.noAttempt) {
                      newMatch = newMatch.copyWith(
                        autoOrder: () => newMatch.autoOrder.followedBy(
                          <AutoGamepieceID>[gamepieceId],
                        ).toList(),
                      );
                    }

                    if (newMatch.autoOrder.contains(gamepieceId) &&
                        state == AutoGamepieceState.noAttempt) {
                      newMatch = newMatch.copyWith(
                        autoOrder: () => newMatch.autoOrder
                            .where(
                              (final AutoGamepieceID element) =>
                                  element != gamepieceId,
                            )
                            .toList(),
                      );
                    }
                    onNewMatch(newMatch);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: isRedAlliance ? buttonColumns : buttonColumns.reversed.toList(),
    );
  }
}

Color getColorByState(
  final AutoGamepieceState gamepieceState,
  final bool isRed,
) {
  switch (gamepieceState) {
    case AutoGamepieceState.noAttempt:
      return Colors.grey;
    case AutoGamepieceState.scoredSpeaker:
      return Colors.green;
    case AutoGamepieceState.missedSpeaker:
      return Colors.amber;
    case AutoGamepieceState.notTaken:
      return Colors.red;
  }
}

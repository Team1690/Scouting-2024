import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
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
  });

  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;

  @override
  Widget build(final BuildContext context) {
    final Map<AutoGamepieceID, AutoGamepieceState> gamepieces =
        match.autoGamepieces.asMap;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            children: AutoGamepieceID.values
                .where(
                  (final AutoGamepieceID element) =>
                      element.title.characters.first == "L",
                )
                .map(
                  (final AutoGamepieceID gamepieceId) => AutonomousGamepiece(
                    state:
                        gamepieces[gamepieceId] ?? AutoGamepieceState.notTaken,
                    gamepieceID: gamepieceId,
                    onSelectedStateOfGamepiece:
                        (final AutoGamepieceState state) {
                      gamepieces[gamepieceId] = state;
                      onNewMatch(
                        match.copyWith(
                          autoGamepieces: () =>
                              AutoGamepieces.fromMap(gamepieces),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: Column(
            children: AutoGamepieceID.values
                .where(
                  (final AutoGamepieceID element) =>
                      element.title.characters.first == "M",
                )
                .map(
                  (final AutoGamepieceID gamepieceId) => AutonomousGamepiece(
                    state:
                        gamepieces[gamepieceId] ?? AutoGamepieceState.notTaken,
                    gamepieceID: gamepieceId,
                    onSelectedStateOfGamepiece:
                        (final AutoGamepieceState state) {
                      gamepieces[gamepieceId] = state;
                      onNewMatch(
                        match.copyWith(
                          autoGamepieces: () =>
                              AutoGamepieces.fromMap(gamepieces),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/autonomous/auto_gamepieces.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/autonomous/autonomous_gamepiece_card.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";

class AutonomousSelector extends StatefulWidget {
  const AutonomousSelector({
    super.key,
    required this.match,
    required this.onNewMatch,
  });

  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;

  @override
  State<AutonomousSelector> createState() => _AutonomousSelectorState();
}

class _AutonomousSelectorState extends State<AutonomousSelector> {
  Map<AutoGamepieceID, AutoGamepieceState> gamepieces =
      <AutoGamepieceID, AutoGamepieceState>{
    AutoGamepieceID.one: AutoGamepieceState.notTaken,
    AutoGamepieceID.two: AutoGamepieceState.notTaken,
    AutoGamepieceID.three: AutoGamepieceState.notTaken,
    AutoGamepieceID.four: AutoGamepieceState.notTaken,
    AutoGamepieceID.five: AutoGamepieceState.notTaken,
    AutoGamepieceID.six: AutoGamepieceState.notTaken,
    AutoGamepieceID.seven: AutoGamepieceState.notTaken,
    AutoGamepieceID.eight: AutoGamepieceState.notTaken,
  };

  @override
  Widget build(final BuildContext context) => Row(
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
                      gamepieceID: gamepieceId,
                      onSelectedStateOfGamepiece:
                          (final AutoGamepieceState state) {
                        gamepieces[gamepieceId] = state;
                        widget.onNewMatch(
                          widget.match.copyWith(
                            autoGamepieces: () =>
                                AutoGamepieces.fromMap(gamepieces),
                          ),
                        );
                        setState(() {});
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
                      gamepieceID: gamepieceId,
                      onSelectedStateOfGamepiece:
                          (final AutoGamepieceState state) {
                        gamepieces[gamepieceId] = state;
                        widget.onNewMatch(
                          widget.match.copyWith(
                            autoGamepieces: () =>
                                AutoGamepieces.fromMap(gamepieces),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );
}

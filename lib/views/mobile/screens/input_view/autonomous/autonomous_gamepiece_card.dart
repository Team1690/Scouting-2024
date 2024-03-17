import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/views/constants.dart";

class AutonomousGamepiece extends StatelessWidget {
  const AutonomousGamepiece({
    super.key,
    required this.gamepieceID,
    required this.onSelectedStateOfGamepiece,
    required this.state,
    this.color,
  });

  final AutoGamepieceID gamepieceID;
  final void Function(AutoGamepieceState) onSelectedStateOfGamepiece;
  final AutoGamepieceState state;
  final Color? color;

  @override
  Widget build(final BuildContext context) => Card(
        color: color,
        margin: const EdgeInsets.all(defaultPadding / 2),
        elevation: 4,
        child: ElevatedButton(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        textAlign: TextAlign.center,
                        state.title,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Icon(state.icon),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onPressed: () {
            AutoGamepieceState newState = state;
            switch (newState) {
              case AutoGamepieceState.noAttempt:
                newState = AutoGamepieceState.scoredSpeaker;
                break;
              case AutoGamepieceState.scoredSpeaker:
                newState = AutoGamepieceState.missedSpeaker;
                break;
              case AutoGamepieceState.missedSpeaker:
                newState = AutoGamepieceState.notTaken;
                break;
              case AutoGamepieceState.notTaken:
                newState = AutoGamepieceState.noAttempt;
                break;
            }
            onSelectedStateOfGamepiece(newState);
          },
        ),
      );
}

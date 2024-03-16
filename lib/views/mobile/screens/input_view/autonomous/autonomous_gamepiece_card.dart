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
            child: Column(
              children: <Widget>[
                Text(
                  "Gamepiece: ${gamepieceID.title}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
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
          onPressed: () async {
            final AutoGamepieceState newState =
                await showDialog<AutoGamepieceState>(
                      context: context,
                      builder: (final BuildContext context) => Dialog(
                        child: SingleChildScrollView(
                          child: Column(
                            children: AutoGamepieceState.values
                                .map(
                                  (final AutoGamepieceState gamepieceState) =>
                                      ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, gamepieceState);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      child: Text(gamepieceState.title),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ) ??
                    state;
            onSelectedStateOfGamepiece(newState);
          },
        ),
      );
}

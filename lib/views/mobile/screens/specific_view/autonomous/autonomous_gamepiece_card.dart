import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/views/constants.dart";

class AutonomousGamepiece extends StatefulWidget {
  const AutonomousGamepiece({
    super.key,
    required this.gamepieceID,
    required this.onSelectedStateOfGamepiece,
  });

  final AutoGamepieceID gamepieceID;
  final void Function(AutoGamepieceState) onSelectedStateOfGamepiece;

  @override
  State<AutonomousGamepiece> createState() => _AutonomousGamepieceState();
}

class _AutonomousGamepieceState extends State<AutonomousGamepiece> {
  AutoGamepieceState gamepieceState = AutoGamepieceState.notTaken;

  @override
  Widget build(final BuildContext context) => Card(
        margin: const EdgeInsets.all(defaultPadding / 2),
        elevation: 4,
        child: ElevatedButton(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: Text("Gamepiece: ${widget.gamepieceID.title}"),
          ),
          onPressed: () async {
            gamepieceState = await showDialog<AutoGamepieceState>(
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
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: Text(gamepieceState.title),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ) ??
                gamepieceState;
            widget.onSelectedStateOfGamepiece(gamepieceState);
          },
        ),
      );
}

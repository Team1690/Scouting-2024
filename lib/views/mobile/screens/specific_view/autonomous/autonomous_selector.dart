import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/autonomous/autonomous_gamepiece_card.dart";

class AutonomousSelector extends StatefulWidget {
  const AutonomousSelector({super.key});

  @override
  State<AutonomousSelector> createState() => _AutonomousSelectorState();
}

class _AutonomousSelectorState extends State<AutonomousSelector> {
  Map<AutoGamepieceID, AutoGamepieceState> gamepieces =
      <AutoGamepieceID, AutoGamepieceState>{
    for (final AutoGamepieceID id in AutoGamepieceID.values)
      id: AutoGamepieceState.notTaken,
  };

  @override
  Widget build(final BuildContext context) => Row(
        children: <Widget>[
          Column(
            children: AutoGamepieceID.values
                .where((final AutoGamepieceID element) =>
                    element.title.characters.first == "L")
                .map(
                  (final AutoGamepieceID gamepieceId) => AutonomousGamepiece(
                    gamepieceID: gamepieceId,
                    onSelectedStateOfGamepiece:
                        (final AutoGamepieceState state) {
                      gamepieces[gamepieceId] = state;
                    },
                  ),
                )
                .toList(),
          ),
          Column(
            children: AutoGamepieceID.values
                .where((final AutoGamepieceID element) =>
                    element.title.characters.first == "M")
                .map(
                  (final AutoGamepieceID gamepieceId) => AutonomousGamepiece(
                    gamepieceID: gamepieceId,
                    onSelectedStateOfGamepiece:
                        (final AutoGamepieceState state) {
                      gamepieces[gamepieceId] = state;
                    },
                  ),
                )
                .toList(),
          )
        ],
      );
}

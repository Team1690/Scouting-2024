import "package:flutter/material.dart";
import "package:scouting_frontend/models/providers/scouter_provider.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/scouter_selection.dart";

class ScouterNameInput extends StatelessWidget {
  const ScouterNameInput({
    required this.scouterNameController,
    required this.onScouterNameChange,
  });

  final void Function(String scouterName) onScouterNameChange;
  final TextEditingController scouterNameController;

  @override
  Widget build(final BuildContext context) => ScouterSearchBox(
        typeAheadController: scouterNameController,
        onChanged: onScouterNameChange,
        scouters: ScouterProvider.of(context).scouters,
      );
}

import "package:flutter/material.dart";
import "package:scouting_frontend/models/providers/scouter_provider.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/scouter_selection.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/edit_shift.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

class ChangeScouter extends StatefulWidget {
  ChangeScouter({
    super.key,
    required this.scouters,
    required this.scoutingShift,
  });
  final ScoutingShift scoutingShift;
  final List<String> scouters;

  @override
  State<ChangeScouter> createState() => _ChangeScouterState();
}

class _ChangeScouterState extends State<ChangeScouter> {
  final TextEditingController controller = TextEditingController();
  String name = "";

  @override
  Widget build(final BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Change Scouter"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ScouterSearchBox(
                typeAheadController: controller,
                onChanged: (final String scouterName) {
                  setState(() {
                    name = scouterName;
                  });
                },
                scouters: ScouterProvider.of(context).scouters,
              ),
            ),
            TextButton(
              onPressed: () {
                changeName(
                  name,
                  widget.scoutingShift.team.id,
                  widget.scoutingShift.scheduleId,
                );
                Navigator.of(context).pop(controller.text);
              },
              child: const Text("Change"),
            ),
          ],
        ),
      );
}

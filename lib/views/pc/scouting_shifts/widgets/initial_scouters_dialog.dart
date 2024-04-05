import "package:flutter/material.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/functions/calc_shifts.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/add_scouter.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/add_shift.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

class InitialScoutersDialog extends StatefulWidget {
  const InitialScoutersDialog({super.key});

  @override
  State<InitialScoutersDialog> createState() => _InitialScoutersDialogState();
}

class _InitialScoutersDialogState extends State<InitialScoutersDialog> {
  TextEditingController addController = TextEditingController();
  List<String> scouters = <String>[];

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: addController,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (addController.text != "") {
                      scouters.add(addController.text);
                    }
                    addController.clear();
                  });
                  setState(() {});
                },
                icon: const Icon(Icons.person_add_alt_1),
              ),
              ...scouters.map((e) => TextField(
                    controller: TextEditingController(text: e),
                    onChanged: (value) {
                      setState(() {
                        scouters[scouters.indexOf(e)] = value;
                      });
                    },
                  )),
              IconButton(
                onPressed: () {
                  scouters.forEach(addScouter);
                  final List<ScoutingShift> shifts =
                      calcScoutingShifts(context, scouters);
                  shifts.forEach(addShift);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.schedule_send),
              ),
            ],
          ),
        ),
      );
}

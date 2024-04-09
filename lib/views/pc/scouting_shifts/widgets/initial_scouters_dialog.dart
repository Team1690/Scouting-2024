import "package:flutter/material.dart";
import "package:scouting_frontend/net/fetch_scouters.dart";
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
  Widget build(final BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                },
                icon: const Icon(Icons.person_add_alt_1),
              ),
              ...scouters.map(
                (final String e) => Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: e),
                        onChanged: (final String value) {
                          setState(() {
                            scouters[scouters.indexOf(e)] = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          scouters.remove(e);
                        });
                      },
                      icon: const Icon(Icons.group_remove),
                    ),
                  ],
                ),
              ),
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

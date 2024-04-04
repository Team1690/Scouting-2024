import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/widgets/initial_scouters_dialog.dart";

class InitialScouters extends StatefulWidget {
  const InitialScouters({super.key});

  @override
  State<InitialScouters> createState() => _InitialScoutersState();
}

class _InitialScoutersState extends State<InitialScouters> {
  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          AppBar(
            backgroundColor: bgColor,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (final BuildContext context) =>
                        const InitialScoutersDialog(),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1),
              ),
              const Spacer(),
            ],
          ),
        ],
      );
}

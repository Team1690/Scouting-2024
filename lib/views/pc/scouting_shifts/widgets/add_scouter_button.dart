import "package:flutter/material.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/add_scouter.dart";

class AddScouterButton extends StatefulWidget {
  const AddScouterButton({super.key});

  @override
  State<AddScouterButton> createState() => _AddScouterButtonState();
}

class _AddScouterButtonState extends State<AddScouterButton> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(final BuildContext context) => IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (final BuildContext context) => Dialog(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: nameController,
                  ),
                  TextButton(
                    onPressed: () {
                      addScouter(nameController.text);
                    },
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
      );
}

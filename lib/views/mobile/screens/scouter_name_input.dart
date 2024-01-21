import "package:flutter/material.dart";

class ScouterNameInput extends StatelessWidget {
  const ScouterNameInput({
    required this.scouterNameController,
    required this.onScouterNameChange,
  });

  final void Function(String scouterName) onScouterNameChange;
  final TextEditingController scouterNameController;

  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: scouterNameController,
        validator: (final String? value) =>
            value != null && value.isNotEmpty ? null : "Please enter your name",
        onChanged: onScouterNameChange,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
          hintText: "Scouter name",
        ),
      );
}

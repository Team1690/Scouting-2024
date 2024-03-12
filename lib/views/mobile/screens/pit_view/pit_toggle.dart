import "package:flutter/material.dart";

class PitToggle extends StatelessWidget {
  const PitToggle({
    super.key,
    required this.setState,
    required this.isSelected,
    required this.title,
  });
  final void Function() setState;
  final List<bool> isSelected;
  final String title;

  @override
  Widget build(final BuildContext context) => ToggleButtons(
        fillColor: const Color.fromARGB(10, 244, 67, 54),
        selectedColor: Colors.blue,
        selectedBorderColor: Colors.blue,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(title),
          ),
        ],
        isSelected: isSelected,
        onPressed: (final int i) => setState,
      );
}

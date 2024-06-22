import "package:flutter/material.dart";

class PitToggle extends StatelessWidget {
  const PitToggle({
    super.key,
    required this.onPressed,
    required this.isSelected,
    required this.titles,
  });

  final void Function(int) onPressed;
  final List<bool> isSelected;
  final List<String> titles;

  @override
  Widget build(final BuildContext context) => ToggleButtons(
        // You know what I think of balls
        fillColor: const Color.fromARGB(10, 244, 67, 54),
        selectedColor: Colors.blue,
        selectedBorderColor: Colors.blue,
        children: <Widget>[
          ...titles.map(Text.new),
        ],
        isSelected: isSelected,
        onPressed: onPressed,
      );
}

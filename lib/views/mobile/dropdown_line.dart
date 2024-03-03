import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";

class RatingDropdownLine<T> extends StatelessWidget {
  RatingDropdownLine({
    required this.onChange,
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final double? value;
  final void Function() onTap;
  final void Function(double) onChange;

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: SectionDivider(label: label),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: value == null
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Container(),
            secondChild: Column(
              children: <Widget>[
                Slider(
                  value: value ?? 1,
                  onChanged: onChange,
                  min: 1,
                  max: 3,
                  divisions: 2,
                  label: value.toString(),
                ),
              ],
            ),
          ),
        ],
      );
}

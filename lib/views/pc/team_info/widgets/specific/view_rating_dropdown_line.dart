import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/scouting_specific.dart";

class ViewRatingDropdownLine extends StatefulWidget {
  ViewRatingDropdownLine({
    required this.color,
    required this.label,
    required this.ratingToMatch,
  });
  final String label;
  final Color color;
  final List<(int, int)> ratingToMatch;

  @override
  State<ViewRatingDropdownLine> createState() => _ViewRatingDropdownLineState();
}

class _ViewRatingDropdownLineState extends State<ViewRatingDropdownLine> {
  bool isPressed = false;

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isPressed = !isPressed;
              });
            },
            child: SectionDivider(
              label: widget.label,
              color: widget.color,
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: !isPressed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Container(),
            secondChild: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ...widget.ratingToMatch.map(
                  (final (int, int) e) => Tooltip(
                    message: "match number: ${e.$2}",
                    child: Text(
                      "${getRating(e.$1.toDouble()).$1}, ",
                      style: TextStyle(color: getRating(e.$1.toDouble()).$2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

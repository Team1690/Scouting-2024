import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/scouting_specific.dart";

class ViewRatingDropdownLine extends StatefulWidget {
  const ViewRatingDropdownLine({
    super.key,
    required this.rating,
    required this.ratingToMatch,
    required this.label,
  });

  final Rating rating;
  final List<(int, int)> ratingToMatch;
  final String label;

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
              label: "${widget.rating.letter} (${widget.label})",
              color: widget.rating.color,
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
                      "${getRating(e.$1.toDouble(), e.$2).letter}, ",
                      style: TextStyle(
                        color: getRating(e.$1.toDouble(), e.$2).color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

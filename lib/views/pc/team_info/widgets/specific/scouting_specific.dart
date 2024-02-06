import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_data/specific_summary_data.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";

class ScoutingSpecific extends StatefulWidget {
  const ScoutingSpecific({required this.msgs, required this.matchesData});
  final SpecificSummaryData msgs;
  final List<MatchData> matchesData;

  @override
  State<ScoutingSpecific> createState() => _ScoutingSpecificState();
}

class _ScoutingSpecificState extends State<ScoutingSpecific> {
  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getSummaryText(
              "Driving",
              widget.msgs.drivingText,
              widget.matchesData
                  .map(
                    (final MatchData e) =>
                        e.specificMatchData?.drivetrainAndDriving.mapNullable(
                      (final int a) => (
                        e.specificMatchData!.drivetrainAndDriving!,
                        e.scheduleMatch.matchIdentifier.number
                      ),
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Speaker",
              widget.msgs.speakerText,
              widget.matchesData
                  .map(
                    (final MatchData e) =>
                        e.specificMatchData?.speaker.mapNullable(
                      (final int a) => (
                        e.specificMatchData!.speaker!,
                        e.scheduleMatch.matchIdentifier.number
                      ),
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Amp",
              widget.msgs.ampText,
              widget.matchesData
                  .map(
                    (final MatchData e) => e.specificMatchData?.amp.mapNullable(
                      (final int a) => (
                        e.specificMatchData!.amp!,
                        e.scheduleMatch.matchIdentifier.number
                      ),
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Intake",
              widget.msgs.intakeText,
              widget.matchesData
                  .map(
                    (final MatchData e) =>
                        e.specificMatchData?.intake.mapNullable(
                      (final int a) => (
                        e.specificMatchData!.intake!,
                        e.scheduleMatch.matchIdentifier.number
                      ),
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Climb",
              widget.msgs.climbText,
              widget.matchesData
                  .map(
                    (final MatchData e) =>
                        e.specificMatchData?.climb.mapNullable(
                      (final int a) => (
                        e.specificMatchData!.climb!,
                        e.scheduleMatch.matchIdentifier.number
                      ),
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "General",
              widget.msgs.generalText,
              widget.matchesData
                  .map(
                    (final MatchData e) =>
                        e.specificMatchData?.general.mapNullable(
                      (final int a) => (
                        e.specificMatchData!.general!,
                        e.scheduleMatch.matchIdentifier.number
                      ),
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Defense",
              widget.msgs.defenseText,
              widget.matchesData
                  .map(
                    (final MatchData e) =>
                        e.specificMatchData?.defense.mapNullable(
                      (final int a) => (
                        e.specificMatchData!.defense!,
                        e.scheduleMatch.matchIdentifier.number
                      ),
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            //TODO add a button to autoScreen when complete
          ],
        ),
      );

  Widget getSummaryText(
    final String title,
    final String text,
    final List<(int, int)> ratingsToMatches,
  ) {
    final (String, Color) rating = getRating(
      ratingsToMatches
              .map((final (int, int) e) => e.$1)
              .toList()
              .averageOrNull ??
          0,
    );
    return text.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ViewRatingDropdownLine(
                label: "$title (${rating.$1})",
                color: rating.$2,
                ratingToMatch: ratingsToMatches,
              ),
              Text(
                text,
                textAlign: TextAlign.right,
              ),
            ]
                .expand(
                  (final Widget element) => <Widget>[
                    element,
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )
                .toList(),
          )
        : Container();
  }
}

(String, Color) getRating(final double numeralRating) {
  switch (numeralRating.round()) {
    case 1:
      return ("F", Colors.red);
    case 2:
      return ("F", Colors.red);
    case 3:
      return ("D", Colors.orange);
    case 4:
      return ("D", Colors.orange);
    case 5:
      return ("C", Colors.yellow);
    case 6:
      return ("C", Colors.yellow);
    case 7:
      return ("B", Colors.green);
    case 8:
      return ("B", Colors.green);
    case 9:
      return ("A", const Color.fromARGB(255, 30, 124, 33));
    case 10:
      return ("A", const Color.fromARGB(255, 30, 124, 33));
    default:
      return ("No Data", Colors.white);
  }
}

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

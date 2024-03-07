import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/data/specific_summary_data.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/pc/alliance_auto_planner/auto_planner_screen.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/view_rating_dropdown_line.dart";

class ScoutingSpecific extends StatefulWidget {
  const ScoutingSpecific({
    required this.msgs,
    required this.matchesData,
    required this.team,
  });
  final LightTeam team;
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
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<AutoPlannerScreen>(
                  builder: (final BuildContext context) =>
                      AutoPlannerScreen(<LightTeam>[widget.team]),
                ),
              ),
              child: const Text("View Auto"),
            ),
            getSummaryText(
              "Driving",
              widget.msgs.drivingText,
              widget.matchesData.specificMatches
                  .map(
                    (final MatchData match) => (
                      match.specificMatchData!.drivetrainAndDriving ?? 0,
                      match.scheduleMatch.matchIdentifier.number
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Speaker",
              widget.msgs.speakerText,
              widget.matchesData.specificMatches
                  .map(
                    (final MatchData match) => (
                      match.specificMatchData!.speaker ?? 0,
                      match.scheduleMatch.matchIdentifier.number
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Amp",
              widget.msgs.ampText,
              widget.matchesData.specificMatches
                  .map(
                    (final MatchData match) => (
                      match.specificMatchData!.amp ?? 0,
                      match.scheduleMatch.matchIdentifier.number
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Intake",
              widget.msgs.intakeText,
              widget.matchesData.specificMatches
                  .map(
                    (final MatchData match) => (
                      match.specificMatchData!.intake ?? 0,
                      match.scheduleMatch.matchIdentifier.number
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Climb",
              widget.msgs.climbText,
              widget.matchesData.specificMatches
                  .map(
                    (final MatchData match) => (
                      match.specificMatchData!.climb ?? 0,
                      match.scheduleMatch.matchIdentifier.number
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "General",
              widget.msgs.generalText,
              widget.matchesData.specificMatches
                  .map(
                    (final MatchData match) => (
                      match.specificMatchData!.general ?? 0,
                      match.scheduleMatch.matchIdentifier.number
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
            getSummaryText(
              "Defense",
              widget.msgs.defenseText,
              widget.matchesData.specificMatches
                  .map(
                    (final MatchData match) => (
                      match.specificMatchData!.defense ?? 0,
                      match.scheduleMatch.matchIdentifier.number
                    ),
                  )
                  .whereNotNull()
                  .toList(),
            ),
          ],
        ),
      );
  Widget getSummaryText(
    final String title,
    final String text,
    final List<(int rating, int matchNumber)> ratingsToMatches,
  ) {
    final (String, Color) rating = getRating(
      ratingsToMatches
              .map((final (int, int) e) => e.$1)
              .where(
                  (final int element) => !element.isNaN && !element.isInfinite)
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
      return ("D", Colors.orange);
    case 3:
      return ("C", Colors.yellow);
    case 4:
      return ("B", Colors.lightGreen);
    case 5:
      return ("A", Colors.green[800]!);
    default:
      return ("No Data", Colors.white);
  }
}

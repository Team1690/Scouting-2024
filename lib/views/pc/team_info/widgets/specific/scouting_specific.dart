import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/data/specific_match_data.dart";
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
              (msg) => msg.drivingText,
              (match) => match.drivetrainAndDriving,
            ),
            getSummaryText(
              "Speaker",
              (msg) => msg.speakerText,
              (match) => match.speaker,
            ),
            getSummaryText(
              "Amp",
              (msg) => msg.ampText,
              (match) => match.amp,
            ),
            getSummaryText(
              "Intake",
              (msg) => msg.intakeText,
              (match) => match.intake,
            ),
            getSummaryText(
              "Climb",
              (msg) => msg.climbText,
              (match) => match.climb,
            ),
            getSummaryText(
              "General",
              (msg) => msg.generalText,
              (match) => match.general,
            ),
            getSummaryText(
              "Defense",
              (final SpecificSummaryData message) => message.defenseText,
              (final SpecificMatchData match) => match.defense,
            ),
          ],
        ),
      );
  Widget getSummaryText(
    final String title,
    final String Function(SpecificSummaryData) text,
    final int? Function(SpecificMatchData) matchRating,
  ) {
    final List<(int, int)> matchToRating = widget.matchesData.specificMatches
        .where(
          (final MatchData element) =>
              matchRating(element.specificMatchData!) != null,
        )
        .map(
          (final MatchData match) => (
            matchRating(match.specificMatchData!)!,
            match.scheduleMatch.matchIdentifier.number
          ),
        )
        .toList();
    final Rating rating = getRating(
      matchToRating.map((final (int, int) e) => e.$1).toList().averageOrNull ??
          0,
    );
    return text(widget.msgs).isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ViewRatingDropdownLine(
                rating: rating,
                ratingToMatch: matchToRating,
                label: title,
              ),
              Text(
                text(widget.msgs),
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

Rating getRating(final double numeralRating, [final int matchNumber = 0]) {
  switch (numeralRating.ceil()) {
    case 1:
      return (letter: "F", color: Colors.red, rating: 1, match: matchNumber);
    case 2:
      return (letter: "D", color: Colors.orange, rating: 2, match: matchNumber);
    case 3:
      return (letter: "C", color: Colors.yellow, rating: 3, match: matchNumber);
    case 4:
      return (
        letter: "B",
        color: Colors.lightGreen,
        rating: 4,
        match: matchNumber
      );
    case 5:
      return (
        letter: "A",
        color: Colors.green[800]!,
        rating: 5,
        match: matchNumber
      );
    default:
      return (
        letter: "No Data",
        color: Colors.white,
        rating: 0,
        match: matchNumber
      );
  }
}

typedef Rating = ({int rating, int match, String letter, Color color});

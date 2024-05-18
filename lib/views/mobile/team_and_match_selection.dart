import "package:flutter/material.dart";
import "package:scouting_frontend/models/providers/shifts_provider.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/providers/matches_provider.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/teams_search_box.dart";
import "package:scouting_frontend/models/providers/team_provider.dart";
import "package:scouting_frontend/views/common/validated_auto_coplete.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

class TeamAndMatchSelection extends StatefulWidget {
  const TeamAndMatchSelection({
    required this.onChange,
    required this.matchController,
    required this.teamNumberController,
    this.scouter,
  });
  final TextEditingController matchController;
  final TextEditingController teamNumberController;
  final void Function(
    ScheduleMatch,
    LightTeam?,
  ) onChange;
  final String? scouter;
  @override
  State<TeamAndMatchSelection> createState() => TeamAndMatchSelectionState();
}

class TeamAndMatchSelectionState extends State<TeamAndMatchSelection> {
  ScheduleMatch? scheduleMatch;
  List<LightTeam> teams = <LightTeam>[];
  LightTeam? team;

  @override
  Widget build(final BuildContext context) {
    final List<ScoutingShift> shifts = ShiftProvider.of(context)
        .shifts
        .where((final ScoutingShift element) => element.name == widget.scouter)
        .toList();

    return Column(
      children: <Widget>[
        if (MatchesProvider.of(context).matches.isEmpty)
          const Text("No matches found :(")
        else
          MatchSearchBox(
            typeAheadController: widget.matchController,
            matches: MatchesProvider.of(context)
                .matches
                .where(
                  (final ScheduleMatch element) =>
                      !element.matchIdentifier.isRematch &&
                      (widget.scouter != null && shifts.isNotEmpty
                          ? shifts
                              .map((final ScoutingShift e) => e.matchIdentifier)
                              .contains(element.matchIdentifier)
                          : true),
                )
                .toList(),
            onChange: (final ScheduleMatch selectedMatch) {
              setState(() {
                scheduleMatch = selectedMatch;
                teams = selectedMatch.isUnofficial
                    ? TeamProvider.of(context).teams
                    : <LightTeam>[
                        ...selectedMatch.blueAlliance,
                        ...selectedMatch.redAlliance,
                      ];
                widget.teamNumberController.clear();
                widget.onChange(selectedMatch, null);
              });
            },
          ),
        const SizedBox(
          height: 15,
        ),
        if (scheduleMatch != null)
          TeamsSearchBox(
            buildSuggestion: (final LightTeam currentTeam) {
              final List<ScoutingShift> shifts =
                  ShiftProvider.of(context).shifts;

              return scheduleMatch!.isUnofficial
                  ? "${currentTeam.number} ${currentTeam.name}"
                  : scheduleMatch!.getTeamStation(currentTeam, shifts);
            },
            teams: teams,
            typeAheadController: widget.teamNumberController,
            onChange: (final LightTeam team) {
              setState(() {
                widget.onChange(scheduleMatch!, team);
              });
            },
          ),
      ],
    );
  }
}

class MatchSearchBox extends StatelessWidget {
  MatchSearchBox({
    required this.matches,
    required this.onChange,
    required this.typeAheadController,
  });
  final List<ScheduleMatch> matches;
  final void Function(ScheduleMatch) onChange;
  final TextEditingController typeAheadController;
  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: matches.isEmpty
            ? const Text(
                "No Matches Found",
                style: TextStyle(fontSize: 16),
              )
            : ValidatedAutocomplete<ScheduleMatch>(
                validator: (final ScheduleMatch? selectedMatch) {
                  if (selectedMatch == null) {
                    return "Please pick a match";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Enter Match",
                ),
                onSelected: (final ScheduleMatch suggestion) {
                  typeAheadController.text =
                      "${suggestion.matchIdentifier.type.title} ${suggestion.matchIdentifier.number}";

                  onChange(
                    matches[matches.indexWhere(
                      (final ScheduleMatch match) =>
                          match.matchIdentifier.number ==
                              suggestion.matchIdentifier.number &&
                          match.matchIdentifier.type ==
                              suggestion.matchIdentifier.type,
                    )],
                  );
                },
                optionsBuilder: (final TextEditingValue textEditingValue) =>
                    matches.where(
                  (final ScheduleMatch match) => match.matchIdentifier.number
                      .toString()
                      .startsWith(textEditingValue.text),
                ),
                displayStringForOption: (final ScheduleMatch suggestion) =>
                    "${suggestion.matchIdentifier.type.title} ${suggestion.matchIdentifier.number}",
              ),
      );
}

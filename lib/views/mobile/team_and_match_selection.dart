import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/matches_provider.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/teams_search_box.dart";

class TeamAndMatchSelection extends StatefulWidget {
  const TeamAndMatchSelection({
    required this.onChange,
    required this.matchController,
    required this.teamNumberController,
  });
  final TextEditingController matchController;
  final TextEditingController teamNumberController;
  final void Function(
    ScheduleMatch,
    LightTeam?,
  ) onChange;
  @override
  State<TeamAndMatchSelection> createState() => TeamAndMatchSelectionState();
}

class TeamAndMatchSelectionState extends State<TeamAndMatchSelection> {
  ScheduleMatch? scheduleMatch;
  List<LightTeam> teams = <LightTeam>[];
  LightTeam? team;
  bool isUnofficial(final ScheduleMatch match) => <MatchType>[
        MatchType.pre,
        MatchType.practice,
      ].contains(match.matchIdentifier.type);

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          if (MatchesProvider.of(context).matches.isEmpty)
            const Text("No matches found :(")
          else
            MatchSearchBox(
              typeAheadController: widget.matchController,
              matches: MatchesProvider.of(context)
                  .matches
                  .whereNot(
                    (final ScheduleMatch element) =>
                        element.matchIdentifier.isRematch,
                  )
                  .toList(),
              onChange: (final ScheduleMatch selectedMatch) {
                setState(() {
                  scheduleMatch = selectedMatch;
                  teams = isUnofficial(selectedMatch)
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
              buildSuggestion: (final LightTeam currentTeam) =>
                  isUnofficial(scheduleMatch!)
                      ? "${currentTeam.number} ${currentTeam.name}"
                      : scheduleMatch!.getTeamStation(currentTeam) ?? "",
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
        child: TypeAheadFormField<ScheduleMatch>(
          validator: (final String? selectedMatch) {
            if (selectedMatch == "") {
              return "Please pick a match";
            }
            return null;
          },
          textFieldConfiguration: TextFieldConfiguration(
            onSubmitted: (final String number) {
              try {
                final ScheduleMatch match = matches.firstWhere(
                  (final ScheduleMatch match) =>
                      match.matchIdentifier.number.toString() == number,
                );
                onChange(match);
                typeAheadController.text =
                    "${match.matchIdentifier.type.title} ${match.matchIdentifier.number}";
              } on StateError catch (_) {
                //ignoed
              }
            },
            onTap: typeAheadController.clear,
            controller: typeAheadController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: "Search Match",
            ),
          ),
          suggestionsCallback: (final String pattern) => matches
              .where(
                (final ScheduleMatch match) =>
                    match.matchIdentifier.number.toString().startsWith(pattern),
              )
              .toList(),
          itemBuilder:
              (final BuildContext context, final ScheduleMatch suggestion) =>
                  ListTile(
            title: Text(
              "${suggestion.matchIdentifier.type.title} ${suggestion.matchIdentifier.number}",
            ),
          ),
          transitionBuilder: (
            final BuildContext context,
            final Widget suggestionsBox,
            final AnimationController? controller,
          ) =>
              FadeTransition(
            child: suggestionsBox,
            opacity: CurvedAnimation(
              parent: controller!,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          noItemsFoundBuilder: (final BuildContext context) => Container(
            height: 60,
            child: const Center(
              child: Text(
                "No Matches Found",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          hideSuggestionsOnKeyboardHide: false,
          onSuggestionSelected: (final ScheduleMatch suggestion) {
            typeAheadController.text =
                "${suggestion.matchIdentifier.type.title} ${suggestion.matchIdentifier.number}";

            onChange(
              matches[matches.indexWhere(
                (final ScheduleMatch match) =>
                    match.matchIdentifier.number ==
                    suggestion.matchIdentifier.number,
              )],
            );
          },
        ),
      );
}

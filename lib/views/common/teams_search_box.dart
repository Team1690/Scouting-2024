import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/validated_auto_coplete.dart";

class TeamsSearchBox extends StatelessWidget {
  TeamsSearchBox({
    required this.buildSuggestion,
    required this.teams,
    required this.onChange,
    required this.typeAheadController,
    this.dontValidate = false,
  });
  final String Function(LightTeam) buildSuggestion;
  final bool dontValidate;
  final List<LightTeam> teams;
  final void Function(LightTeam) onChange;
  final TextEditingController typeAheadController;
  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: teams.isEmpty
            ? const Text(
                "No Teams Found",
                style: TextStyle(fontSize: 16),
              )
            : ValidatedAutocomplete<LightTeam>(
                validator: (final LightTeam? team) {
                  final String? selectedTeam = team?.name;
                  if (dontValidate) {
                    return null;
                  }
                  if (selectedTeam == "") {
                    return "Please pick a team";
                  }
                  return null;
                },
                onSelected: (final LightTeam team) {
                  typeAheadController.text = buildSuggestion(team);
                  onChange(
                    team,
                  );
                },
                decoration: const InputDecoration(
                  hintText: "Enter Team",
                ),
                optionsBuilder: (final TextEditingValue textEditingValue) =>
                    teams
                        .where(
                          (final LightTeam team) => team.number
                              .toString()
                              .startsWith(textEditingValue.text),
                        )
                        .toList()
                      ..sort(
                        (
                          final LightTeam firstTeam,
                          final LightTeam secondTeam,
                        ) =>
                            firstTeam.number.compareTo(secondTeam.number),
                      ),
                displayStringForOption: (final LightTeam option) =>
                    "${option.name}  ${option.number}",
              ),
      );
}

import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/match/specific_ratings.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/match/specific_vars.dart";
import "package:scouting_frontend/views/mobile/submit_button.dart";
import "package:scouting_frontend/views/mobile/team_and_match_selection.dart";

class SpecificMatchCard extends StatefulWidget {
  const SpecificMatchCard({required this.onTeamSelected});
  final void Function(LightTeam) onTeamSelected;
  @override
  State<SpecificMatchCard> createState() => _SpecificMatchCardState();
}

class _SpecificMatchCardState extends State<SpecificMatchCard> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController matchController = TextEditingController();

  late SpecificVars vars = SpecificVars();
  bool intialIsRed = false;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  validator: (final String? value) =>
                      value != null && value.isNotEmpty
                          ? null
                          : "Please enter your name",
                  onChanged: (final String p0) {
                    setState(() {
                      vars = vars.copyWith(name: always(p0));
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    hintText: "Scouter names",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TeamAndMatchSelection(
                  matchController: matchController,
                  teamNumberController: teamController,
                  onChange: (
                    final ScheduleMatch selectedMatch,
                    final LightTeam? selectedTeam,
                  ) {
                    setState(() {
                      vars = vars.copyWith(
                        scheduleMatch: always(selectedMatch),
                        team: always(selectedTeam),
                      );
                      if (selectedTeam != null) {
                        widget.onTeamSelected(selectedTeam);
                      }
                      final ScheduleMatch? scheduleMatch = vars.scheduleMatch;
                      if (scheduleMatch != null &&
                          !<MatchType>[
                            MatchType.pre,
                            MatchType.practice,
                          ].contains(
                            scheduleMatch.matchIdentifier.type,
                          )) {
                        intialIsRed =
                            scheduleMatch.redAlliance.contains(vars.team);
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ToggleButtons(
                  fillColor: const Color.fromARGB(10, 244, 67, 54),
                  selectedColor: Colors.red,
                  selectedBorderColor: Colors.red,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Rematch"),
                    ),
                  ],
                  isSelected: <bool>[vars.isRematch],
                  onPressed: (final int i) {
                    setState(() {
                      vars = vars.copyWith(
                        isRematch: always(!vars.isRematch),
                      );
                    });
                  },
                ),
                const SizedBox(height: 15.0),
                SpecificRating(
                  onChanged: (final SpecificVars vars) => setState(() {
                    this.vars = vars;
                  }),
                  vars: vars,
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SubmitButton(
                    getJson: vars.toJson,
                    validate: () => formKey.currentState!.validate(),
                    resetForm: () {
                      setState(() {
                        vars = vars.reset(context);
                        teamController.clear();
                        matchController.clear();
                      });
                    },
                    mutation: getMutation(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

String getMutation() => """
                mutation A( \$defense_rating: Int, \$driving_rating: Int, \$general_rating: Int, \$intake_rating: Int, \$is_rematch: Boolean, \$speaker_rating: Int, \$scouter_name: String, \$team_id: Int, \$url: String, \$climb_rating: Int, \$amp_rating: Int, \$schedule_match_id: Int){
                  insert_specific_match(objects: {scouter_name: \$scouter_name, team_id: \$team_id, speaker_rating: \$speaker_rating, schedule_match_id: \$schedule_match_id, url: \$url, is_rematch: \$is_rematch, intake_rating: \$intake_rating, general_rating: \$general_rating, driving_rating: \$driving_rating, defense_rating: \$defense_rating, climb_rating: \$climb_rating, amp_rating: \$amp_rating}) {
                    affected_rows
                  }
                      }
                
                """;

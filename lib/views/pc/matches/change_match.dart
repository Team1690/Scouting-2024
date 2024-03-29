import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/mobile/submit_button.dart";
import "package:scouting_frontend/views/pc/matches/matches_vars.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class ChangeMatch extends StatefulWidget {
  const ChangeMatch([this.initialVars]);
  final ScheduleMatch? initialVars;
  @override
  State<ChangeMatch> createState() => _ChangeMatchState();
}

class _ChangeMatchState extends State<ChangeMatch> {
  late MatchesVars vars = widget.initialVars.mapNullable(
        (final ScheduleMatch p) => MatchesVars.fromScheduleMatch(p, context),
      ) ??
      MatchesVars();
  List<TextEditingController> teamControllers =
      List<TextEditingController>.generate(
    8,
    (final int i) => TextEditingController(),
  );
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController numberController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    numberController = TextEditingController(
      text: widget.initialVars == null ? null : vars.matchNumber.toString(),
    );
    final ScheduleMatch? initialVars = widget.initialVars;
    if (initialVars == null) {
      return;
    }

    teamControllers[0] = TextEditingController(
      text: initialVars.blueAlliance[0].number.toString(),
    );
    teamControllers[1] = TextEditingController(
      text: initialVars.blueAlliance[1].number.toString(),
    );
    teamControllers[2] = TextEditingController(
      text: initialVars.blueAlliance[2].number.toString(),
    );
    teamControllers[3] = TextEditingController(
      text: initialVars.blueAlliance.length == 4
          ? initialVars.blueAlliance[3].number.toString()
          : null,
    );
    teamControllers[4] = TextEditingController(
      text: initialVars.redAlliance[0].number.toString(),
    );
    teamControllers[5] = TextEditingController(
      text: initialVars.redAlliance[1].number.toString(),
    );
    teamControllers[6] = TextEditingController(
      text: initialVars.redAlliance[2].number.toString(),
    );
    teamControllers[7] = TextEditingController(
      text: initialVars.redAlliance.length == 4
          ? initialVars.redAlliance[3].number.toString()
          : null,
    );
  }

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: 100,
        height: double.infinity,
        child: AlertDialog(
          title: const Text("Add Match"),
          content: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: "Enter match number",
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  onChanged: ((final String value) {
                    vars.matchNumber = int.tryParse(value);
                  }),
                  validator: (final String? value) =>
                      vars.matchNumber.onNull("Please pick a match number"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Selector<MatchType>(
                  options: MatchType.values,
                  placeholder: "Enter match type",
                  value: vars.matchType,
                  makeItem: (final MatchType p0) => p0.title,
                  onChange: (final MatchType p0) {
                    vars.matchType = p0;
                  },
                  validate: (final MatchType p0) => null,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 300,
                        height: double.infinity,
                        child: ListView(
                          children: <Widget>[
                            SectionDivider(label: "Blue Teams"),
                            TeamSelectionFuture(
                              onChange: (final LightTeam team) =>
                                  vars.blue0 = team,
                              controller: teamControllers[0],
                            ),
                            TeamSelectionFuture(
                              onChange: (final LightTeam team) =>
                                  vars.blue1 = team,
                              controller: teamControllers[1],
                            ),
                            TeamSelectionFuture(
                              onChange: (final LightTeam team) =>
                                  vars.blue2 = team,
                              controller: teamControllers[2],
                            ),
                            SectionDivider(label: "Blue Sub Team"),
                            TeamSelectionFuture(
                              dontValidate: true,
                              onChange: (final LightTeam team) =>
                                  vars.blue3 = team,
                              controller: teamControllers[3],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: double.infinity,
                        child: ListView(
                          children: <Widget>[
                            SectionDivider(label: "Red Teams"),
                            TeamSelectionFuture(
                              onChange: (final LightTeam team) =>
                                  vars.red0 = team,
                              controller: teamControllers[4],
                            ),
                            TeamSelectionFuture(
                              onChange: (final LightTeam team) =>
                                  vars.red1 = team,
                              controller: teamControllers[5],
                            ),
                            TeamSelectionFuture(
                              onChange: (final LightTeam team) =>
                                  vars.red2 = team,
                              controller: teamControllers[6],
                            ),
                            SectionDivider(label: "Red Sub Team"),
                            TeamSelectionFuture(
                              dontValidate: true,
                              onChange: (final LightTeam team) =>
                                  vars.red3 = team,
                              controller: teamControllers[7],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ToggleButtons(
                  fillColor: const Color.fromARGB(10, 244, 67, 54),
                  selectedColor: Colors.blue,
                  selectedBorderColor: Colors.blue,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Happened"),
                    ),
                  ],
                  isSelected: <bool>[vars.happened],
                  onPressed: (final int i) {
                    setState(() {
                      vars.happened = !vars.happened;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SubmitButton(
                  getJson: vars.toJson,
                  mutation: widget.initialVars == null ? insert : update,
                  resetForm: () {},
                  validate: () => formKey.currentState!.validate(),
                ),
              ],
            ),
          ),
        ),
      );
}

const String insert = """
mutation InsertMatch(\$match: schedule_matches_insert_input!){
  insert_schedule_matches_one(object: \$match){
    id
  }
}
""";

const String update = """
mutation UpdateMatch(\$id: Int!,\$match: schedule_matches_set_input!){
  update_schedule_matches_by_pk(_set: \$match, pk_columns: {id: \$id}){
  	id
  }
}

""";

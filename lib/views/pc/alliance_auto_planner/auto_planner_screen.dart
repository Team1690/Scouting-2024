import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_data/starting_position_enum.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "dart:ui" as ui;
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/auto_path/multiple_path_canvas.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/fetch_auto_path.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/select_path.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_view.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";

class AutoPlannerScreen extends StatefulWidget {
  const AutoPlannerScreen([
    this.initialTeams = const <LightTeam>[],
  ]); //TODO add implementation for initialTeams from TeamInfo
  final List<LightTeam> initialTeams;

  @override
  State<AutoPlannerScreen> createState() => _AutoPlannerScreenState();
}

class _AutoPlannerScreenState extends State<AutoPlannerScreen> {
  List<LightTeam> teams = <LightTeam>[];

  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: FutureBuilder<ui.Image>(
          future: getField(false),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<ui.Image> fieldSnapshot,
          ) {
            if (fieldSnapshot.hasError) {
              return Text(fieldSnapshot.error!.toString());
            }
            if (fieldSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return FutureBuilder<
                List<(TeamData, List<(Sketch, StartingPosition)>)>>(
              future: teams.isNotEmpty
                  ? fetchDataAndPaths(
                      context,
                      teams
                          .whereNotNull()
                          .map((final LightTeam e) => e.id)
                          .toList(),
                    )
                  : Future(
                      () => <(TeamData, List<(Sketch, StartingPosition)>)>[],
                    ),
              builder: (
                final BuildContext context,
                final AsyncSnapshot<
                        List<(TeamData, List<(Sketch, StartingPosition)>)>>
                    snapshot,
              ) {
                if (snapshot.hasError) {
                  return Text(snapshot.error!.toString());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ...StartingPosition.values.map(
                              (final StartingPosition e) => Expanded(
                                child: Column(
                                  children: <Widget>[
                                    TeamSelectionFuture(
                                      controller: TextEditingController(),
                                      teams: TeamProvider.of(context).teams,
                                      onChange: (final LightTeam team) {
                                        if (teams.contains(team)) {
                                          return;
                                        }
                                        teams.add(
                                          team,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: const Icon(Icons.route),
                            ),
                          ]
                              .expand(
                                (final Widget element) => <Widget>[
                                  element,
                                  const SizedBox(width: 10),
                                ],
                              )
                              .toList(),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: teams.isEmpty || snapshot.data == null
                            ? const Card()
                            : AutoPlanner(
                                field: fieldSnapshot.data!,
                                data: snapshot.data!,
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
}

class AutoPlanner extends StatefulWidget {
  const AutoPlanner({required this.field, required this.data});
  final ui.Image field;
  final List<
      (
        TeamData,
        List<(Sketch, StartingPosition)>,
      )> data;

  @override
  State<AutoPlanner> createState() => _AutoPlannerState();
}

class _AutoPlannerState extends State<AutoPlanner> {
  List<(StartingPosition, (Sketch, Color))> selectedAutos =
      <(StartingPosition, (Sketch, Color))>[];
  Map<StartingPosition, TeamData?> selectedTeams = Map.fromEntries(
    StartingPosition.values
        .map((final StartingPosition e) => MapEntry(e, null)),
  );
  @override
  Widget build(final BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ...StartingPosition.values.map(
                  (final StartingPosition e) => Card(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text("Starting Near ${e.title}"),
                          Selector<TeamData>(
                            options: widget.data
                                .map(
                                  (
                                    final (
                                      TeamData,
                                      List<(Sketch, StartingPosition)>
                                    ) e,
                                  ) =>
                                      e.$1,
                                )
                                .toList(),
                            placeholder: "Team at ${e.title}",
                            value: selectedTeams[e],
                            makeItem: (final TeamData element) =>
                                "${element.lightTeam.number} ${element.lightTeam.name}",
                            onChange: (final TeamData selectedTeam) {
                              selectedTeams[e] = selectedTeam;
                              selectAuto(selectedTeam, e);
                            },
                            validate: (final TeamData teamData) => null,
                          ),
                          ElevatedButton(
                            onPressed: () => selectAuto(selectedTeams[e], e),
                            child: const Text("Select auto"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: MultiplePathCanvas(
              fieldImage: widget.field,
              sketches: selectedAutos
                  .map((final (StartingPosition, (Sketch, Color)) e) => e.$2)
                  .toList(),
            ),
          ),
        ],
      );

  void selectAuto(
    final TeamData? teamData,
    final StartingPosition startingPos,
  ) async {
    final Sketch? selectedAuto = await showDialog<Sketch?>(
      context: context,
      builder: (final BuildContext dialogContext) => SelectPath(
        fieldBackgrounds: (widget.field, widget.field),
        existingPaths: widget.data
                .firstWhereOrNull(
                  (final (
                            TeamData,
                            List<(Sketch, StartingPosition)>
                          ) element) =>
                      element.$1.lightTeam == teamData?.lightTeam,
                )
                ?.$2
                .where(
                  (final (Sketch, StartingPosition) element) =>
                      teamData?.technicalMatches
                          .where(
                            (final TechnicalMatchData element) =>
                                element.startingPosition == startingPos,
                          )
                          .map((final TechnicalMatchData element) =>
                              element.startingPosition)
                          .contains(element.$2) ??
                      false,
                )
                .map((final (Sketch, StartingPosition) e) => e.$1)
                .toList() ??
            <Sketch>[],
        onNewSketch: (final Sketch sketch) {
          Navigator.pop(context, sketch);
        },
      ),
    );
    if (selectedAuto == null) return;
    setState(() {
      selectedAutos.removeWhere(
        (
          final (StartingPosition, (Sketch, Color)) element,
        ) =>
            element.$1 == startingPos,
      );
      selectedAutos.add(
        (
          startingPos,
          (
            selectedAuto,
            selectedTeams[startingPos]?.lightTeam.color ?? Colors.white
          )
        ),
      );
    });
  }
}

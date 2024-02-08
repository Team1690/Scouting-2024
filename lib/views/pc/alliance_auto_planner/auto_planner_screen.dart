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

class AutoPlannerScreen extends StatefulWidget {
  const AutoPlannerScreen([
    this.initialTeams = const <LightTeam>[],
  ]); //TODO add implementation for initialTeams from TeamInfo
  final List<LightTeam> initialTeams;

  @override
  State<AutoPlannerScreen> createState() => _AutoPlannerScreenState();
}

class _AutoPlannerScreenState extends State<AutoPlannerScreen> {
  List<LightTeam?> teams = List.filled(StartingPosition.values.length, null);

  List<TextEditingController> controllers = List.generate(
      StartingPosition.values.length, (i) => TextEditingController());
  ui.Image? field;

  @override
  Widget build(final BuildContext context) => DashboardScaffold(
          body: FutureBuilder<
              List<
                  (
                    TeamData,
                    List<(Sketch, StartingPosition, MatchIdentifier)>
                  )>>(
        future: teams.whereNotNull().isNotEmpty
            ? fetchDataAndPaths(
                context,
                teams.whereNotNull().map((final LightTeam e) => e.id).toList(),
              )
            : Future<
                List<
                    (
                      TeamData,
                      List<(Sketch, StartingPosition, MatchIdentifier)>
                    )>>(
                () => <(
                  TeamData,
                  List<(Sketch, StartingPosition, MatchIdentifier)>
                )>[],
              ),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<
                  List<
                      (
                        TeamData,
                        List<(Sketch, StartingPosition, MatchIdentifier)>
                      )>>
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ...StartingPosition.values.map(
                        (final StartingPosition e) => Expanded(
                          child: TeamSelectionFuture(
                            controller:
                                controllers[StartingPosition.values.indexOf(e)],
                            teams: TeamProvider.of(context).teams,
                            onChange: (final LightTeam team) {
                              if (teams.contains(team)) {
                                return;
                              }
                              teams[StartingPosition.values.indexOf(e)] = team;
                            },
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
                  child: teams.isEmpty || snapshot.data == null || field == null
                      ? const Card()
                      : AutoPlanner(
                          field: field!,
                          data: snapshot.data!,
                        ),
                ),
              ],
            ),
          );
        },
      ));
}

class AutoPlanner extends StatefulWidget {
  const AutoPlanner({required this.field, required this.data});
  final ui.Image field;
  final List<
      (
        TeamData,
        List<(Sketch, StartingPosition, MatchIdentifier)>,
      )> data;

  @override
  State<AutoPlanner> createState() => _AutoPlannerState();
}

class _AutoPlannerState extends State<AutoPlanner> {
  Map<StartingPosition, (Sketch, Color)?> selectedAutos =
      Map<StartingPosition, (Sketch, Color)?>.fromEntries(
    StartingPosition.values.map(
      (final StartingPosition e) =>
          MapEntry<StartingPosition, (Sketch, Color)?>(e, null),
    ),
  );
  Map<StartingPosition, TeamData?> selectedTeams =
      Map<StartingPosition, TeamData?>.fromEntries(
    StartingPosition.values.map(
      (final StartingPosition e) =>
          MapEntry<StartingPosition, TeamData?>(e, null),
    ),
  );

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ...StartingPosition.values.map(
                    (final StartingPosition e) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Starting Near ${e.title}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Selector<TeamData>(
                                options: widget.data
                                    .map(
                                      (
                                        final (
                                          TeamData,
                                          List<
                                              (
                                                Sketch,
                                                StartingPosition,
                                                MatchIdentifier
                                              )>
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
                                  selectAuto(e);
                                },
                                validate: (final TeamData teamData) => null,
                              ),
                              selectedAutos[e] != null
                                  ? Column(
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () => selectAuto(e),
                                          child: const Text("Select auto"),
                                        ),
                                        autoDataText(e),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: MultiplePathCanvas(
              fieldImage: widget.field,
              sketches: selectedAutos.values.whereNotNull().toList(),
            ),
          ),
        ],
      );

  Column autoDataText(final StartingPosition startingPosition) {
    final List<TechnicalMatchData> technicalMatches =
        getAutoData(startingPosition);
    final double avgAmp = technicalMatches
            .map((final TechnicalMatchData match) => match.data.autoAmp)
            .toList()
            .averageOrNull ??
        double.nan;
    final num bestAmp = technicalMatches
            .map((final TechnicalMatchData match) => match.data.autoAmp)
            .toList()
            .maxOrNull ??
        double.nan;
    final double avgSpeaker = technicalMatches
            .map((final TechnicalMatchData match) => match.data.autoSpeaker)
            .toList()
            .averageOrNull ??
        double.nan;
    final num bestSpeaker = technicalMatches
            .map((final TechnicalMatchData match) => match.data.autoSpeaker)
            .toList()
            .maxOrNull ??
        double.nan;
    final int matchesUsed = technicalMatches.length;
    return Column(
      children: <Widget>[
        if (avgAmp > 0) ...<Widget>[
          Text("Avg Amp: $avgAmp"),
          Text("Best Amp: $bestAmp")
        ],
        if (avgSpeaker > 0) ...<Widget>[
          Text("Avg Speaker: $avgSpeaker"),
          Text("Best Speaker: $bestSpeaker")
        ],
        Text("Matches Used: $matchesUsed"),
      ],
    );
  }

  List<TechnicalMatchData> getAutoData(
    final StartingPosition startingPos,
  ) {
    final List<(Sketch, StartingPosition, MatchIdentifier)> matchesAtPos =
        widget.data
            .where((final (
                      TeamData,
                      List<(Sketch, StartingPosition, MatchIdentifier)>
                    ) e) =>
                e.$1.lightTeam == selectedTeams[startingPos]?.lightTeam)
            .map((final (
                      TeamData,
                      List<(Sketch, StartingPosition, MatchIdentifier)>
                    ) e) =>
                e.$2.where((final (
                          Sketch,
                          StartingPosition,
                          MatchIdentifier
                        ) element) =>
                    element.$2 == startingPos))
            .flattened
            .toList();
    final List<MatchIdentifier> matchesUsingAuto = matchesAtPos
        .where((final (Sketch, StartingPosition, MatchIdentifier) match) =>
            match.$1 == selectedAutos[startingPos]?.$1)
        .map((e) => e.$3)
        .toList();
    return selectedTeams[startingPos]!
        .technicalMatches
        .where((match) => matchesUsingAuto.contains(match.matchIdentifier))
        .toList();
  }

  void selectAuto(
    final StartingPosition startingPos,
  ) async {
    final Sketch? selectedAuto = await showDialog<Sketch?>(
      context: context,
      builder: (final BuildContext dialogContext) {
        final List<(Sketch, StartingPosition, MatchIdentifier)> matchesAtPos =
            widget.data
                .where((final (
                          TeamData,
                          List<(Sketch, StartingPosition, MatchIdentifier)>
                        ) e) =>
                    e.$1.lightTeam == selectedTeams[startingPos]?.lightTeam)
                .map((final (
                          TeamData,
                          List<(Sketch, StartingPosition, MatchIdentifier)>
                        ) e) =>
                    e.$2.where((final (
                              Sketch,
                              StartingPosition,
                              MatchIdentifier
                            ) element) =>
                        element.$2 == startingPos))
                .flattened
                .toList();
        final List<Sketch> uniqueAuto = matchesAtPos
            .map((final (Sketch, StartingPosition, MatchIdentifier) match) =>
                match.$1)
            .fold(<Sketch>[], (previousValue, element) {
          if (!previousValue.contains(element)) previousValue.add(element);
          return previousValue;
        }).toList();

        final List<Sketch> autosAllBlue =
            uniqueAuto.map((auto) => Sketch(points:  , isRed: false, url: auto.url)).toList();

        return SelectPath(
          fieldBackgrounds: (widget.field, widget.field),
          existingPaths: uniqueAuto,
          onNewSketch: (final Sketch sketch) {
            Navigator.pop(context, sketch);
          },
        );
      },
    );
    if (selectedAuto == null) return;
    setState(() {
      selectedAutos[startingPos] = (
        selectedAuto,
        selectedTeams[startingPos]?.lightTeam.color ?? Colors.white
      );
    });
  }
}

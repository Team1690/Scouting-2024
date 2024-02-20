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

class AutoPlannerScreen extends StatelessWidget {
  const AutoPlannerScreen([
    this.initialTeams,
  ]); //TODO add implementation for initialTeams from TeamInfo
  final List<LightTeam>? initialTeams;

  @override
  Widget build(final BuildContext context) => isPC(context)
      ? DashboardScaffold(
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: AutoScreenTeamSelection(initialTeams),
          ),
        )
      : Scaffold(
          appBar: AppBar(
            title: const Text("Alliance Auto"),
            centerTitle: true,
          ),
          drawer: SideNavBar(),
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
              child: AutoScreenTeamSelection(initialTeams),
              scrollDirection: isPC(context) ? Axis.horizontal : Axis.vertical,
            ),
          ),
        );
}

class AutoScreenTeamSelection extends StatefulWidget {
  const AutoScreenTeamSelection([this.initialTeams]);
  final List<LightTeam>? initialTeams;

  @override
  State<AutoScreenTeamSelection> createState() =>
      _AutoScreenTeamSelectionState();
}

class _AutoScreenTeamSelectionState extends State<AutoScreenTeamSelection> {
  late List<LightTeam?> teams = widget.initialTeams ??
      List<LightTeam?>.filled(StartingPosition.values.length, null);

  List<TextEditingController> controllers =
      List<TextEditingController>.generate(
    StartingPosition.values.length,
    (final int i) => TextEditingController(),
  );
  ui.Image? field;

  @override
  Widget build(final BuildContext context) => FutureBuilder<
          List<
              (
                TeamData,
                List<
                    AutoPathData>
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
                      List<
                          AutoPathData>
                    )>>(
                () => <(
                  TeamData,
                  List<
                      AutoPathData>
                )>[],
              ),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<
                  List<
                      (
                        TeamData,
                        List<
                            AutoPathData>
                      )>>
              snapshot,
        ) {
          if (snapshot.hasError) {
            return Text(snapshot.error!.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: <Widget>[
              Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                direction: isPC(context) ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ...StartingPosition.values.map(
                    (final StartingPosition e) => Expanded(
                      flex: isPC(context) ? 1 : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
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
                  ),
                  IconButton(
                    onPressed: () async {
                      field = await getField(false);
                      setState(() {});
                    },
                    icon: const Icon(Icons.route),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: isPC(context) ? 5 : 0,
                child: teams.isEmpty || snapshot.data == null || field == null
                    ? const Card()
                    : AutoPlanner(
                        field: field!,
                        data: snapshot.data!,
                      ),
              ),
            ],
          );
        },
      );
}

class AutoPlanner extends StatefulWidget {
  const AutoPlanner({required this.field, required this.data});
  final ui.Image field;
  final List<
      (
        TeamData,
        List<
            ({
              Sketch sketch,
              StartingPosition startingPos,
              MatchIdentifier matchIdentifier
            })>,
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
  Widget build(final BuildContext context) => Flex(
        direction: isPC(context) ? Axis.horizontal : Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: isPC(context) ? 1 : 0,
            child: shouldScroll(
              shouldScroll: isPC(context),
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
                                style: TextStyle(
                                  fontSize: 20,
                                  color: selectedTeams[e]?.lightTeam.color ??
                                      Colors.white,
                                ),
                              ),
                              Selector<TeamData>(
                                options: widget.data
                                    .map(
                                      (
                                        final (
                                          TeamData,
                                          List<
                                              ({
                                                Sketch sketch,
                                                StartingPosition startingPos,
                                                MatchIdentifier matchIdentifier
                                              })>
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
            flex: isPC(context) ? 2 : 0,
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
          Text("Best Amp: $bestAmp"),
        ],
        if (avgSpeaker > 0) ...<Widget>[
          Text("Avg Speaker: $avgSpeaker"),
          Text("Best Speaker: $bestSpeaker"),
        ],
        Text("Matches Used: $matchesUsed"),
      ],
    );
  }

  List<TechnicalMatchData> getAutoData(
    final StartingPosition startingPos,
  ) {
    final List<
            AutoPathData>
        matchesAtPos = widget.data
            .where(
              (
                final (
                  TeamData,
                  List<
                      AutoPathData>
                ) e,
              ) =>
                  e.$1.lightTeam == selectedTeams[startingPos]?.lightTeam,
            )
            .map(
              (
                final (
                  TeamData,
                  List<
                      AutoPathData>
                ) e,
              ) =>
                  e.$2.where(
                (
                  final AutoPathData element,
                ) =>
                    element.startingPos == startingPos,
              ),
            )
            .flattened
            .toList();
    final List<MatchIdentifier> matchesUsingAuto = matchesAtPos
        .where(
          (
            final AutoPathData match,
          ) =>
              match.sketch.url == selectedAutos[startingPos]?.$1.url,
        )
        .map(
          (
            final AutoPathData e,
          ) =>
              e.matchIdentifier,
        )
        .toList();
    return selectedTeams[startingPos]!
        .technicalMatches
        .where(
          (final TechnicalMatchData match) =>
              matchesUsingAuto.contains(match.matchIdentifier),
        )
        .toList();
  }

  void selectAuto(
    final StartingPosition startingPos,
  ) async {
    final Sketch? selectedAuto = await showDialog<Sketch?>(
      context: context,
      builder: (final BuildContext dialogContext) {
        final List<
                AutoPathData>
            matchesAtPos = widget.data
                .where(
                  (
                    final (
                      TeamData,
                      List<
                          AutoPathData>
                    ) e,
                  ) =>
                      e.$1.lightTeam == selectedTeams[startingPos]?.lightTeam,
                )
                .map(
                  (
                    final (
                      TeamData,
                      List<
                          AutoPathData>
                    ) e,
                  ) =>
                      e.$2.where(
                    (
                      final AutoPathData element,
                    ) =>
                        element.startingPos == startingPos,
                  ),
                )
                .flattened
                .toList();

        final List<Sketch> uniqueAuto = distinct(
          matchesAtPos
              .map(
                (
                  final AutoPathData match,
                ) =>
                    match.sketch,
              )
              .toList(),
        );

        final List<Sketch> autosAllBlue = uniqueAuto
            .map(
              (final Sketch auto) => Sketch(
                points: auto.points
                    .map(
                      (final Offset point) => auto.isRed
                          ? Offset((point.dx - autoFieldWidth).abs(), point.dy)
                          : point,
                    )
                    .toList(),
                isRed: false,
                url: auto.url,
              ),
            )
            .toList();

        return SelectPath(
          fieldBackgrounds: (widget.field, widget.field),
          existingPaths: autosAllBlue,
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

Widget shouldScroll({
  required final Widget child,
  required final bool shouldScroll,
}) =>
    shouldScroll
        ? SingleChildScrollView(
            child: SingleChildScrollView(child: child),
          )
        : child;

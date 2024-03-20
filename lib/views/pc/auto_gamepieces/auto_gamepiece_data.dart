import "dart:math";
import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/list_utils.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/auto_gamepieces/auto_aggregations.dart";
import "package:scouting_frontend/views/pc/auto_gamepieces/auto_gamepiece_notes_selections.dart";
import "package:scouting_frontend/views/pc/auto_gamepieces/auto_pie_chart.dart";
import "package:scouting_frontend/views/pc/auto_gamepieces/note_aggregation.dart";

class AutoGamepiecesData extends StatefulWidget {
  const AutoGamepiecesData({required this.data, required this.field});
  final TeamData data;
  final ui.Image field;

  @override
  State<AutoGamepiecesData> createState() => _AutoGamepiecesDataState();
}

class _AutoGamepiecesDataState extends State<AutoGamepiecesData> {
  int currentAutoIndex = 0;
  AutoGamepieceID? selectedNote;

  @override
  void didUpdateWidget(covariant final AutoGamepiecesData oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentAutoIndex = 0;
    selectedNote = null;
  }

  late final Map<DeepEqList<AutoGamepieceID>, List<TechnicalMatchData>>
      grouped = groupBy(
    widget.data.technicalMatches,
    (final TechnicalMatchData match) => DeepEqList<AutoGamepieceID>(
      match.autoGamepieces
          .map(
            (final (AutoGamepieceID, AutoGamepieceState) autogampiece) =>
                autogampiece.$1,
          )
          .toList(),
    ),
  );

  late final List<
          ({List<AutoGamepieceID> auto, List<TechnicalMatchData> matches})>
      autos = grouped.entries
          .map(
            (
              final MapEntry<DeepEqList<AutoGamepieceID>,
                      List<TechnicalMatchData>>
                  element,
            ) =>
                (auto: element.key.list, matches: element.value),
          )
          .toList();
  @override
  Widget build(final BuildContext context) {
    // print(autos.length);
    if (autos.isEmpty) {
      return const Text("No Data");
    }
    return Flex(
      direction: isPC(context) ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: isPC(context) ? 4 : 0,
          child: SizedBox(
            width: isPC(context) ? 300 : double.infinity,
            child: AutoNoteSelection(
              selectedGamepiece: selectedNote,
              field: widget.field,
              gamepieceOrder: autos[currentAutoIndex].auto,
              onNoteClicked: (final AutoGamepieceID? note) {
                setState(() {
                  if (!autos[currentAutoIndex].auto.contains(note)) {
                    selectedNote = null;
                  } else {
                    selectedNote = note;
                  }
                });
              },
            ),
          ),
        ),
        Expanded(
          flex: isPC(context) ? 3 : 0,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ...autos.mapIndexed(
                      (
                        final int index,
                        final ({
                          List<AutoGamepieceID> auto,
                          List<TechnicalMatchData> matches
                        }) e,
                      ) =>
                          Icon(
                        size: 15,
                        currentAutoIndex == index
                            ? Icons.circle
                            : Icons.circle_outlined,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentAutoIndex = max(0, currentAutoIndex - 1);
                          selectedNote = null;
                        });
                      },
                      icon: const Icon(Icons.skip_previous),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentAutoIndex =
                              min(autos.length - 1, currentAutoIndex + 1);
                          selectedNote = null;
                        });
                      },
                      icon: const Icon(Icons.skip_next),
                    ),
                  ],
                ),
                if (autos[currentAutoIndex].auto.isNotEmpty) ...<Widget>[
                  AutoAggreagte(
                    technicalMatchData: autos[currentAutoIndex].matches,
                  ),
                  if (selectedNote != null) ...<Widget>[
                    NoteAggregation(
                      selectedNote: selectedNote!,
                      auto: autos[currentAutoIndex],
                    ),
                    LayoutBuilder(
                      builder: (
                        final BuildContext context,
                        final BoxConstraints constraints,
                      ) =>
                          SizedBox(
                        height: constraints.maxWidth * 0.5,
                        child: AutoPieChart(
                          selected: selectedNote!,
                          matches: autos[currentAutoIndex].matches,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";

class NoteAggregation extends StatelessWidget {
  NoteAggregation({
    super.key,
    required this.selectedNote,
    required this.auto,
  });
  final AutoGamepieceID selectedNote;
  final ({List<AutoGamepieceID> auto, List<TechnicalMatchData> matches}) auto;
  final Set<AutoGamepieceState> scored = <AutoGamepieceState>{
    AutoGamepieceState.scoredSpeaker,
  };
  final Set<AutoGamepieceState> intaked = <AutoGamepieceState>{
    AutoGamepieceState.missedSpeaker,
    AutoGamepieceState.scoredSpeaker,
  };
  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Text(
            "${selectedNote.title} Stats",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            "Intake Percantage: ${getPercentage(auto, intaked).toStringAsFixed(2)}%",
          ),
          Text(
            "Score Percantage: ${getPercentage(auto, scored).toStringAsFixed(2)}%",
          ),
        ],
      );

  double getPercentage(
    final ({List<AutoGamepieceID> auto, List<TechnicalMatchData> matches}) auto,
    final Set<AutoGamepieceState> options,
  ) {
    final List<AutoGamepieceState?> totalInteractions = auto.matches
        .map(
          (final TechnicalMatchData e) => e.autoGamepieces
              .firstWhereOrNull(
                (final (AutoGamepieceID, AutoGamepieceState) element) =>
                    element.$1 == selectedNote,
              )
              ?.$2,
        )
        .whereNotNull() // Happens when selectedNote is not in the auto
        .toList();
    return totalInteractions.where(options.contains).length /
        totalInteractions.length *
        100;
  }
}

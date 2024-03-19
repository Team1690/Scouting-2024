import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/views/common/dashboard_piechart.dart";

AutoGamepieceState getValueInAuto(
  final AutoGamepieceID id,
  final List<(AutoGamepieceID, AutoGamepieceState)> autoGamepieces,
) =>
    autoGamepieces
        .singleWhere(
          (final (AutoGamepieceID, AutoGamepieceState) element) =>
              element.$1 == id,
        )
        .$2;

class AutoPieChart extends StatelessWidget {
  const AutoPieChart({
    required this.selected,
    required this.matches,
  });
  final AutoGamepieceID selected;
  final List<TechnicalMatchData> matches;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder:
            (final BuildContext context, final BoxConstraints contraints) =>
                DashboardPieChart(
          radius: contraints.maxWidth * 0.2,
          sections: matches
              .map(
                (final TechnicalMatchData match) =>
                    getValueInAuto(selected, match.autoGamepieces),
              )
              .groupFoldBy<AutoGamepieceState, int>(
                identity,
                (final int? previous, final AutoGamepieceState element) =>
                    (previous ?? 0) + 1,
              )
              .entries
              .map(
                (
                  final MapEntry<AutoGamepieceState, int> gamepieceAggregation,
                ) =>
                    (
                  gamepieceAggregation.value,
                  gamepieceAggregation.key.title,
                  gamepieceAggregation.key.color
                ),
              )
              .toList(),
        ),
      );
}

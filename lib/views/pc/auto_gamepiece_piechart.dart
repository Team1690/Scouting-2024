import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/views/common/dashboard_piechart.dart";

class AutoGamepiecePieChart extends StatelessWidget {
  const AutoGamepiecePieChart({super.key, required this.gamepieces});

  final List<(AutoGamepieceState, int)> gamepieces;

  @override
  Widget build(final BuildContext context) => DashboardPieChart(
        sections: gamepieces
            .map(
              (final (AutoGamepieceState, int) e) =>
                  (e.$2, e.$1.title, e.$1.color),
            )
            .toList(),
      );
}

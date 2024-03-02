import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";

class StatusRow extends StatelessWidget {
  const StatusRow({
    super.key,
    this.leading,
    required this.statusBoxBuilder,
    required this.data,
    required this.missingStatusBoxBuilder,
    required this.missingData,
  });

  final Widget? leading;
  final Widget Function(MatchData) statusBoxBuilder;
  final Widget Function(MatchData) missingStatusBoxBuilder;
  final List<MatchData> data;
  final List<MatchData> missingData;

  @override
  Widget build(final BuildContext context) => Card(
        color: bgColor,
        elevation: 2,
        margin: const EdgeInsets.all(defaultPadding / 2),
        child: Container(
          padding: const EdgeInsets.all(2 * defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (leading != null) leading!,
              ...data.map(statusBoxBuilder),
              ...missingData.map(missingStatusBoxBuilder),
            ],
          ),
        ),
      );
}

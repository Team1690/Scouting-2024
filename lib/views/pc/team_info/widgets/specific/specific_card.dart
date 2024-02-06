import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_data/specific_summary_data.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/scouting_specific.dart";

class SpecificCard extends StatefulWidget {
  const SpecificCard({required this.matchData, required this.summaryData});
  final List<MatchData?> matchData;
  final SpecificSummaryData? summaryData;

  @override
  State<SpecificCard> createState() => _SpecificCardState();
}

class _SpecificCardState extends State<SpecificCard> {
  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "Specific Scouting",
        body: widget.summaryData != null
            ? ScoutingSpecific(
                msgs: widget.summaryData!,
                matchesData: widget.matchData.whereNotNull().toList(),
              )
            : const Text("No Summary Found :("),
      );
}

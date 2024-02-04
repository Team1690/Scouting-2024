import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_match_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_summary_data.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/scouting_specific.dart";

class SpecificCard extends StatefulWidget {
  const SpecificCard({required this.matchData, required this.summaryData});
  final List<SpecificMatchData?> matchData;
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

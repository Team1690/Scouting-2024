import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/pc/status/status_row.dart";

class StatusList<T> extends StatelessWidget {
  const StatusList({
    super.key,
    required this.data,
    required this.groupBy,
    required this.statusBoxBuilder,
    this.leading,
    this.orderByCompare,
    required this.missingStatusBoxBuilder,
    required this.isMissingValidator,
  });

  final List<MatchData> data;
  final T Function(MatchData) groupBy;
  final int Function(MatchData, MatchData)? orderByCompare;
  final bool Function(MatchData) isMissingValidator;
  final Widget Function(MatchData) statusBoxBuilder;
  final Widget Function(MatchData) missingStatusBoxBuilder;
  final Widget? Function(List<MatchData>)? leading;
  @override
  Widget build(final BuildContext context) {
    final List<List<MatchData>> groupedList = data
        .sorted(orderByCompare ?? (final MatchData a, final MatchData b) => 1)
        .groupListsBy(groupBy)
        .values
        .toList();
    return SingleChildScrollView(
      child: Column(
        children: groupedList
            .where((row) => row.whereNot(isMissingValidator).isNotEmpty)
            .map(
              (final List<MatchData> row) => StatusRow(
                statusBoxBuilder: statusBoxBuilder,
                data: row.whereNot(isMissingValidator).toList(),
                leading: leading?.call(row),
                missingStatusBoxBuilder: missingStatusBoxBuilder,
                missingData: row.where(isMissingValidator).toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}

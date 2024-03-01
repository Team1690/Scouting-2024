import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/views/pc/status/status_row.dart";

class StatusList<T> extends StatelessWidget {
  const StatusList({
    super.key,
    required this.data,
    required this.groupBy,
    required this.statusBoxBuilder,
    this.leading,
    this.orderBy,
  });

  final List<MatchData> data;
  final T Function(MatchData) groupBy;
  final int Function(MatchData, MatchData)? orderBy;
  final Widget Function(MatchData) statusBoxBuilder;
  final Widget? Function(List<MatchData>)? leading;
  @override
  Widget build(final BuildContext context) {
    final List<List<MatchData>> groupedList = data
        .sorted(orderBy ?? (final MatchData a, final MatchData b) => 1)
        .groupListsBy(groupBy)
        .values
        .toList();
    return SingleChildScrollView(
      child: Column(
        children: groupedList
            .map(
              (final List<MatchData> row) => StatusRow(
                statusBoxBuilder: statusBoxBuilder,
                data: row,
                leading: leading == null ? null : leading!(row),
              ),
            )
            .toList(),
      ),
    );
  }
}

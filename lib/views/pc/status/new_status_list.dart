import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/views/pc/status/status_row.dart";

class StatusList<T> extends StatelessWidget {
  const StatusList({
    super.key,
    required this.data,
    required this.groupBy,
    required this.statusBoxBuilder,
    this.leading,
  });

  final List<TeamData> data;
  final T Function(TeamData) groupBy;
  final Widget Function(TeamData) statusBoxBuilder;
  final Widget? leading;
  @override
  Widget build(final BuildContext context) {
    final List<List<TeamData>> groupedList =
        data.groupListsBy(groupBy).values.toList();
    return SingleChildScrollView(
      child: Column(
        children: groupedList
            .map(
              (final List<TeamData> row) => StatusRow(
                statusBoxBuilder: statusBoxBuilder,
                data: row,
                leading: leading,
              ),
            )
            .toList(),
      ),
    );
  }
}

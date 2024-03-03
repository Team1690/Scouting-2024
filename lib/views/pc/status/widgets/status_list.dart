import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/pc/status/widgets/status_row.dart";

class StatusList<T, ItemDataType> extends StatelessWidget {
  const StatusList({
    super.key,
    required this.data,
    required this.groupBy,
    required this.statusBoxBuilder,
    this.leading,
    this.orderByCompare,
    required this.missingStatusBoxBuilder,
    required this.isMissingValidator,
    this.orderRowByCompare,
  });

  final List<ItemDataType> data;
  final T Function(ItemDataType) groupBy;
  final int Function(ItemDataType, ItemDataType)? orderByCompare;
  final int Function(ItemDataType, ItemDataType)? orderRowByCompare;
  final bool Function(ItemDataType) isMissingValidator;
  final Widget Function(ItemDataType) statusBoxBuilder;
  final Widget Function(ItemDataType) missingStatusBoxBuilder;
  final Widget? Function(List<ItemDataType>)? leading;
  @override
  Widget build(final BuildContext context) {
    final List<List<ItemDataType>> groupedList = data
        .sorted(
          orderByCompare ?? (final ItemDataType a, final ItemDataType b) => 1,
        )
        .groupListsBy(groupBy)
        .values
        .toList();
    return SingleChildScrollView(
      child: Column(
        children: groupedList
            .where(
              (final List<ItemDataType> row) =>
                  row.whereNot(isMissingValidator).isNotEmpty,
            )
            .map(
              (final List<ItemDataType> row) => StatusRow<ItemDataType>(
                statusBoxBuilder: statusBoxBuilder,
                data: row.whereNot(isMissingValidator).toList(),
                leading: leading?.call(row),
                missingStatusBoxBuilder: missingStatusBoxBuilder,
                missingData: row.where(isMissingValidator).toList(),
                orderRowByCompare: orderRowByCompare,
              ),
            )
            .toList(),
      ),
    );
  }
}

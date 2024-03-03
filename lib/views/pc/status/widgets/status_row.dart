import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";

class StatusRow<ItemDataType> extends StatelessWidget {
  const StatusRow({
    super.key,
    this.leading,
    required this.statusBoxBuilder,
    required this.data,
    required this.missingStatusBoxBuilder,
    required this.missingData,
    this.orderRowByCompare,
  });

  final Widget? leading;
  final Widget Function(ItemDataType) statusBoxBuilder;
  final Widget Function(ItemDataType) missingStatusBoxBuilder;
  final int Function(ItemDataType, ItemDataType)? orderRowByCompare;
  final List<ItemDataType> data;
  final List<ItemDataType> missingData;

  @override
  Widget build(final BuildContext context) => Card(
        color: bgColor,
        elevation: 4,
        margin: const EdgeInsets.all(defaultPadding / 2),
        child: Container(
          padding: const EdgeInsets.all(2 * defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (leading != null) leading!,
              ...data
                  .sorted(
                    orderRowByCompare ??
                        (final ItemDataType a, final ItemDataType b) => 1,
                  )
                  .map(statusBoxBuilder),
              ...missingData
                  .sorted(
                    orderRowByCompare ??
                        (final ItemDataType a, final ItemDataType b) => 1,
                  )
                  .map(missingStatusBoxBuilder),
            ],
          ),
        ),
      );
}

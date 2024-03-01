import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/status/widgets/status_box.dart";
import "package:scouting_frontend/views/pc/status/status_item.dart";

class StatusList<T, V> extends StatelessWidget {
  StatusList({
    required this.items,
    required this.getTitle,
    required this.validate,
    required this.getValueBox,
    required this.validateSpecificValue,
    this.missingBuilder,
    this.pushUnvalidatedToTheTop = false,
  }) {
    if (pushUnvalidatedToTheTop) {
      items.sort(
        (final StatusItem<T, V> statusItemA, final StatusItem<T, V> _) =>
            validate(statusItemA) ? 1 : -1,
      );
    }
  }
  final Widget Function(V)? missingBuilder;
  final List<StatusItem<T, V>> items;
  final bool Function(StatusItem<T, V>) validate;
  final Widget Function(StatusItem<T, V>) getTitle;
  final Widget Function(V, StatusItem<T, V>) getValueBox;
  final MaterialColor? Function(V, StatusItem<T, V>) validateSpecificValue;
  final bool pushUnvalidatedToTheTop;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        primary: false,
        child: Column(
          children: items
              .map(
                (final StatusItem<T, V> statusItem) => Card(
                  color: validate(statusItem) ? bgColor : Colors.red,
                  elevation: 2,
                  margin: const EdgeInsets.fromLTRB(
                    5,
                    0,
                    5,
                    defaultPadding,
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      defaultPadding,
                      defaultPadding / 4,
                      defaultPadding,
                      defaultPadding / 4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        defaultPadding / 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          getTitle(statusItem),
                          ...statusItem.values.map(
                            (
                              final V identifier,
                            ) =>
                                StatusBox(
                              child: getValueBox(identifier, statusItem),
                              backgroundColor: validateSpecificValue(
                                identifier,
                                statusItem,
                              ),
                            ),
                          ),
                          if (missingBuilder != null)
                            ...statusItem.missingValues.map(
                              (final V match) => StatusBox(
                                child: missingBuilder!(match),
                                backgroundColor: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
}

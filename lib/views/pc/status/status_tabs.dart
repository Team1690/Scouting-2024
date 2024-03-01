import "package:flutter/material.dart";

class StatusTabs extends StatefulWidget {
  const StatusTabs({
    super.key,
    required this.onChanged,
  });

  final void Function({bool isSpecific, bool isPreScouting}) onChanged;
  @override
  State<StatusTabs> createState() => _StatusTabsState();
}

class _StatusTabsState extends State<StatusTabs> {
  bool isSpecific = false;
  bool isPreScouting = false;
  @override
  Widget build(final BuildContext context) => Row(
        children: <Widget>[
          ToggleButtons(
            children: const <Widget>[
              Text("Technical"),
              Text("Specific"),
              Text("Pre Scouting"),
            ],
            isSelected: <bool>[
              !isSpecific,
              isSpecific,
              isPreScouting,
            ],
            onPressed: (final int index) {
              setState(() {
                switch (index) {
                  case 0:
                    isSpecific = false;
                    break;
                  case 1:
                    isSpecific = true;
                    break;
                  case 2:
                    isPreScouting = !isPreScouting;
                    break;
                }
              });
              widget.onChanged(
                isSpecific: isSpecific,
                isPreScouting: isPreScouting,
              );
            },
          ),
        ],
      );
}

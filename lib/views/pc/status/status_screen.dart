import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";

import "pre_scouting_status.dart";
import "regular_status.dart";

class StatusScreen extends StatefulWidget {
  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  bool isSpecific = false;
  bool isPreScouting = false;
  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: DashboardCard(
            titleWidgets: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ToggleButtons(
                  children: <Widget>[
                    const Text("Technic"),
                    const Text("Specific"),
                    const Text("Pre"),
                  ]
                      .map(
                        (final Widget text) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: text,
                        ),
                      )
                      .toList(),
                  isSelected: <bool>[!isSpecific, isSpecific, isPreScouting],
                  onPressed: (final int pressedIndex) {
                    if (pressedIndex == 0) {
                      setState(() {
                        isSpecific = false;
                      });
                    } else if (pressedIndex == 1) {
                      setState(() {
                        isSpecific = true;
                      });
                    } else if (pressedIndex == 2) {
                      setState(() {
                        isPreScouting = !isPreScouting;
                      });
                    }
                  },
                ),
              ),
            ],
            title: "",
            body: isPreScouting
                ? PreScoutingStatus(isSpecific)
                : RegularStatus(isSpecific),
          ),
        ),
      );
}

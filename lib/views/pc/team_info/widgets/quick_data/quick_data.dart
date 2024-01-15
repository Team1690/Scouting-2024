import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class QuickDataCard extends StatelessWidget {
  const QuickDataCard(this.data);
  final QuickData data;
  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "Quick data",
        body: data.amoutOfMatches == 0
            ? Container(
                child: const Text("TODO :D"),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    const Column(
                      children: <Widget>[
                        Text(
                          "Auto",
                          style: TextStyle(fontSize: 18),
                        ),
                        //TODO Auto quickdata
                      ],
                    ),
                    const Column(
                      children: <Widget>[
                        Text(
                          "Teleop",
                          style: TextStyle(fontSize: 18),
                        ),
                        //TODO tele quickdata
                      ],
                    ),
                    const Column(
                      children: <Widget>[
                        Text(
                          "Points",
                          style: TextStyle(fontSize: 18),
                        ),
                        //TODO points quickdata
                      ],
                    ),
                    const Column(
                      children: <Widget>[
                        Text(
                          "Misc",
                          style: TextStyle(fontSize: 18),
                        ),
                        //TODO misc quickdata
                      ],
                    ),
                    const Column(
                      children: <Widget>[
                        Text(
                          "Defense Stats",
                          style: TextStyle(fontSize: 18),
                        ),
                        //TODO defense quickdata
                      ],
                    ),
                    const Column(
                      children: <Widget>[
                        Text(
                          "Picklist",
                          style: TextStyle(fontSize: 18),
                        ),
                        //TODO picklist quickdata
                      ],
                    ),
                  ]
                      .expand(
                        (final Widget element) =>
                            <Widget>[element, const SizedBox(width: 40)],
                      )
                      .toList(),
                ),
              ),
      );
}

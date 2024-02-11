import "package:flutter/material.dart";

class CoachTeamInfoLineChart extends StatelessWidget {
  const CoachTeamInfoLineChart(this.linechart, this.title);
  final Widget linechart;
  final String title;

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(title),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.only(left: 25, top: 8.0),
              child: linechart,
            ),
          ),
          const Spacer(),
        ],
      );
}

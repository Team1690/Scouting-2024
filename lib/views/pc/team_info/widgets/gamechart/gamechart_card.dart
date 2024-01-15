import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class Gamechart extends StatelessWidget {
  const Gamechart(this.data);
  final Team data;
  @override
  Widget build(final BuildContext context) => const DashboardCard(
        title: "Game Chart",
        body:
            // data.autoBalanceData.points[0].isEmpty
            // ? Center(
            //     child: Container(),
            //   )
            // : data.autoBalanceData.points[0].length == 1
            //     ? const Text("Not enough data for line chart")
            //     : CarouselWithIndicator()
            Text("TODO :D"),
      );
  //TODO add gamecharts here, note that gamecharts should only be displayed if there are 2 or more points in the graph (add validator)
}

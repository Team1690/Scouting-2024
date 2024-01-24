import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/common/dashboard_linechart.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class TitledLineChart extends StatelessWidget {
  const TitledLineChart({
    required this.data,
    required this.heightToTitles,
  });

  final LineChartData data;
  final Map<int, String> heightToTitles;
  @override
  Widget build(final BuildContext context) => Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(data.title),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
              left: 40.0,
              right: 20.0,
              top: 40,
            ),
            child: DashboardTitledLineChart(
              showShadow: true,
              defenseAmounts: data.defenseAmounts,
              inputedColors: const <Color>[primaryColor],
              gameNumbers: data.gameNumbers,
              dataSet: data.points,
              robotFieldStatuses: data.robotFieldStatuses,
              heightsToTitles: heightToTitles,
            ),
          ),
        ],
      );
}

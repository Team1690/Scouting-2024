import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

class DashboardPieChart extends StatefulWidget {
  const DashboardPieChart({
    super.key,
    required this.sections,
    required this.radius,
  });

  final List<(int, String text, Color)> sections;
  final double radius;

  @override
  State<DashboardPieChart> createState() => DashboardPieChartState();
}

class DashboardPieChartState extends State<DashboardPieChart> {
  int touchedIndex = -1;

  List<PieChartSectionData> showingSections() => widget.sections.mapIndexed(
          (final int index, final (int, String text, Color) section) {
        final bool isTouched = index == touchedIndex;
        final double fontSize = isTouched ? 20.0 : 8.0;
        final double radius = isTouched ? widget.radius * 1.1 : widget.radius;
        const List<Shadow> shadows = <Shadow>[
          Shadow(color: Colors.black, blurRadius: 2),
        ];
        return PieChartSectionData(
          color: section.$3,
          value: section.$1.toDouble(),
          title: isTouched ? section.$1.toString() : section.$2,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
        );
      }).toList();

  @override
  Widget build(final BuildContext context) => PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (
              final FlTouchEvent event,
              final PieTouchResponse? pieTouchResponse,
            ) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: showingSections(),
        ),
      );
}

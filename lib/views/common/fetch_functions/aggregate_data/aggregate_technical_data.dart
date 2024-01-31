import "package:scouting_frontend/views/common/fetch_functions/aggregate_data/avg_technical_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/aggregate_data/max_technical_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/aggregate_data/min_technical_data.dart";

class AggregateData {
  AggregateData({
    required this.maxData,
    required this.minData,
    required this.avgData,
  });
  final MaxData maxData;
  final MinData minData;
  final AvgData avgData;

  static AggregateData parse(final dynamic aggregateTable) => AggregateData(
        maxData: MaxData.parse(aggregateTable["max"]),
        minData: MinData.parse(aggregateTable["min"]),
        avgData: AvgData.parse(aggregateTable["avg"]),
      );
}

import "package:scouting_frontend/models/team_data/technical_data.dart";

class AggregateData {
  AggregateData({
    required this.avgData,
    required this.minData,
    required this.maxData,
    required this.stddev,
    required this.variance,
    required this.sumTotal,
    required this.gamesPlayed,
  });

  final TechnicalData<double> avgData;
  final TechnicalData<int> minData;
  final TechnicalData<int> maxData;
  final TechnicalData<double> stddev;
  final TechnicalData<double> variance;
  final TechnicalData<int> sumTotal;
  final int gamesPlayed;

  static AggregateData parse(final dynamic aggregateTable) => AggregateData(
        avgData: TechnicalData.parse(aggregateTable["avg"]),
        minData: TechnicalData.parse(aggregateTable["min"]),
        maxData: TechnicalData.parse(aggregateTable["max"]),
        stddev: TechnicalData.parse(aggregateTable["stddev"]),
        variance: TechnicalData.parse(aggregateTable["variance"]),
        sumTotal: TechnicalData.parse(aggregateTable["sum"]),
        gamesPlayed: aggregateTable["count"] as int? ?? 0,
      );
}

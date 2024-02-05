import 'package:scouting_frontend/models/team_data/technical_data.dart';

class AggregateData {
  AggregateData({
    required this.avgData,
    required this.minData,
    required this.maxData,
    required this.stddev,
    required this.variance,
    required this.sumTotal,
  });

  final TechnicalData avgData;
  final TechnicalData minData;
  final TechnicalData maxData;
  final TechnicalData stddev;
  final TechnicalData variance;
  final TechnicalData sumTotal;

  static AggregateData parse(final dynamic aggregateTable) => AggregateData(
        avgData: TechnicalData.parse(aggregateTable["avg"]),
        minData: TechnicalData.parse(aggregateTable["min"]),
        maxData: TechnicalData.parse(aggregateTable["max"]),
        stddev: TechnicalData.parse(aggregateTable["stddev"]),
        variance: TechnicalData.parse(aggregateTable["var"]),
        sumTotal: TechnicalData.parse(aggregateTable["sum"]),
      );
}

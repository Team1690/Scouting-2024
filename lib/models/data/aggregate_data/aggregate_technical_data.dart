import "package:collection/collection.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/math_utils.dart";
import "package:scouting_frontend/models/data/calculated_technical_data.dart";
import "package:scouting_frontend/models/data/technical_data.dart";

class AggregateData {
  AggregateData({
    required this.avgData,
    required this.minData,
    required this.maxData,
    required this.stddevData,
    required this.varianceData,
    required this.sumData,
    required this.meanDeviationData,
    required this.medianData,
    required this.gamesPlayed,
  });

  AggregateData.fromTechnicalData(final List<TechnicalData<int>> data)
      : avgData = CalculatedTechnicalData<double>(
          technicalDatas: data,
          calculateFieldAggregateData: findAvg,
        ),
        minData = CalculatedTechnicalData<int>(
          calculateFieldAggregateData: findMin,
          technicalDatas: data,
        ),
        maxData = CalculatedTechnicalData<int>(
          calculateFieldAggregateData: findMax,
          technicalDatas: data,
        ),
        stddevData = CalculatedTechnicalData<double>(
          calculateFieldAggregateData: findStddev,
          technicalDatas: data,
        ),
        varianceData = CalculatedTechnicalData<double>(
          calculateFieldAggregateData: findVariance,
          technicalDatas: data,
        ),
        sumData = CalculatedTechnicalData<int>(
          calculateFieldAggregateData: findSum,
          technicalDatas: data,
        ),
        meanDeviationData = CalculatedTechnicalData<double>(
          calculateFieldAggregateData: findMeanDeviation,
          technicalDatas: data,
        ),
        medianData = CalculatedTechnicalData<double>(
          calculateFieldAggregateData: findMedian,
          technicalDatas: data,
        ),
        gamesPlayed = data.length;

  final CalculatedTechnicalData<double> avgData;
  final CalculatedTechnicalData<int> minData;
  final CalculatedTechnicalData<int> maxData;
  final CalculatedTechnicalData<double> stddevData;
  final CalculatedTechnicalData<double> varianceData;
  final CalculatedTechnicalData<int> sumData;
  final CalculatedTechnicalData<double> meanDeviationData;
  final CalculatedTechnicalData<double> medianData;
  final int gamesPlayed;
}

double findAvg(
  final List<TechnicalData<int>> technicalDatas,
  final int Function(TechnicalData<int>) getField,
) =>
    technicalDatas.map(getField).toList().averageOrNull ?? double.nan;

int findMax(
  final List<TechnicalData<int>> technicalDatas,
  final int Function(TechnicalData<int>) getField,
) =>
    technicalDatas.map(getField).maxOrNull ?? -1;

int findMin(
  final List<TechnicalData<int>> technicalDatas,
  final int Function(TechnicalData<int>) getField,
) =>
    technicalDatas.map(getField).minOrNull ?? -1;

double findStddev(
  final List<TechnicalData<int>> technicalDatas,
  final int Function(TechnicalData<int>) getField,
) =>
    technicalDatas.map(getField).stddevOrNull ?? double.nan;

double findVariance(
  final List<TechnicalData<int>> technicalDatas,
  final int Function(TechnicalData<int>) getField,
) =>
    technicalDatas.map(getField).varianceOrNull ?? double.nan;

int findSum(
  final List<TechnicalData<int>> technicalDatas,
  final int Function(TechnicalData<int>) getField,
) =>
    technicalDatas.map(getField).sumOrNull ?? -1;

double findMeanDeviation(
  final List<TechnicalData<int>> technicalDatas,
  final int Function(TechnicalData<int>) getField,
) =>
    technicalDatas.map(getField).standardError;

double findMedian(
  final List<TechnicalData<int>> technicalDatas,
  final int Function(TechnicalData<int>) getField,
) =>
    technicalDatas.map(getField).medianOrNull ?? double.nan;

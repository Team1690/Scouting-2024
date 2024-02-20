import "dart:math";

import "package:collection/collection.dart";
import "package:scouting_frontend/models/data/technical_data.dart";

extension ListStatisticsExtensions<T extends num> on Iterable<T> {
  double get median {
    final int middleIndex = length ~/ 2;
    final List<T> sortedDataset = sorted(
      (final T a, final T b) => a.compareTo(b),
    );
    return (length % 2 == 0
        ? (sortedDataset[middleIndex - 1] + sortedDataset[middleIndex]) / 2
        : sortedDataset[middleIndex].toDouble());
  }

  double? get medianOrNull => isEmpty ? null : median;

  double get stddev {
    final double avg = average;
    return sqrt(map((final T e) => pow(e - avg, 2)).sum / length);
  }

  double? get stddevOrNull => isEmpty ? null : stddev;

  double get variance => pow(stddev, 2).toDouble();
  double? get varianceOrNull => isEmpty ? null : variance;

  double get standardError =>
      map((final T e) => (e - average).abs()).sum / length;
  double? get standardErrorOrNull => isEmpty ? null : standardError;

  int? get sumOrNull => isEmpty ? null : sum.numericCast();
}

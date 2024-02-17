import "package:flutter/material.dart";

enum FaultStatus {
  unknown("Unknown", Colors.orange),
  noProgress("No progress", Colors.red),
  inProgress("In progress", Colors.yellow),
  fixed("Fixed", Colors.green);

  const FaultStatus(this.title, this.color);
  final String title;
  final Color color;
}

FaultStatus faultStatusTitleToEnum(final String title) =>
    FaultStatus.values
        .where(
          (final FaultStatus faultStatusOption) =>
              faultStatusOption.title == title,
        )
        .singleOrNull ??
    (throw Exception("Invalid title: $title"));

import "package:flutter/material.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";

enum FaultStatus implements IdEnum {
  unknown("Unknown", Colors.orange),
  noProgress("No progress", Colors.red),
  inProgress("In progress", Colors.yellow),
  fixed("Fixed", Colors.green);

  const FaultStatus(this.title, this.color);
  @override
  final String title;
  final Color color;
}

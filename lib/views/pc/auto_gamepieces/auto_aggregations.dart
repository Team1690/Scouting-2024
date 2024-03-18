import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";

class AutoAggreagte extends StatelessWidget {
  AutoAggreagte({super.key, required this.technicalMatchData});
  final List<TechnicalMatchData> technicalMatchData;
  late final AggregateData aggregateData =
      technicalMatchData.scoutingAggregations;

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          const Text(
            "General Stats",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Played In: ${aggregateData.gamesPlayed}",
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Median",
          ),
          Text(
            "Median Gamepieces: ${aggregateData.medianData.autoGamepieces.toStringAsFixed(2)}",
          ),
          Text(
            "Median Misses: ${aggregateData.medianData.autoSpeakerMissed.toStringAsFixed(2)}",
          ),
          Text(
            "Median Points: ${aggregateData.medianData.autoPoints.toStringAsFixed(2)}",
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Max",
          ),
          Text(
            "Max Gamepieces: ${aggregateData.maxData.autoGamepieces.toStringAsFixed(2)}",
          ),
          Text(
            "Max Misses: ${aggregateData.maxData.autoSpeakerMissed.toStringAsFixed(2)}",
          ),
          Text(
            "Max Points: ${aggregateData.maxData.autoPoints.toStringAsFixed(2)}",
          ),
        ],
      );
}

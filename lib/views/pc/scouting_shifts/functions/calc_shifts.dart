import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/matches_provider.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

List<ScoutingShift> calcScoutingShifts(
  final BuildContext context,
  final List<String> scouters,
) {
  final List<List<ScheduleMatch>> matchBatches = MatchesProvider.of(context)
      .matches
      .where(
        (ScheduleMatch element) => element.matchIdentifier.isRematch == false,
      )
      .slices(scoutingShiftLength)
      .toList();

  final List<List<String>> scoutingBatches = scouters.slices(6).toList();
  List<ScoutingShift> shifts = matchBatches
      .mapIndexed(
        (matchBatchIndex, matchBatch) => matchBatch
            .map(
              (match) =>
                  match.redAlliance.followedBy(match.blueAlliance).mapIndexed(
                        (teamIndex, team) => ScoutingShift(
                          name: scoutingBatches[matchBatchIndex %
                              (scoutingBatches.length - 1)][teamIndex % 6],
                          matchIdentifier: match.matchIdentifier,
                          team: team,
                        ),
                      ),
            )
            .flattened,
      )
      .flattened
      .toList();
  return shifts;
}

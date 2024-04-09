import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/providers/matches_provider.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

List<ScoutingShift> calcScoutingShifts(
  final BuildContext context,
  final List<String> scouters,
) {
  final List<List<ScheduleMatch>> matchBatches = MatchesProvider.of(context)
      .matches
      .whereNot(
        (final ScheduleMatch element) =>
            element.matchIdentifier.isRematch ||
            element.matchIdentifier.type != MatchType.quals,
      )
      .slices(scoutingShiftLength)
      .toList();

  final List<List<String>> scoutingBatches =
      scouters.slices(6).where((element) => element.length == 6).toList();
  return matchBatches
      .mapIndexed(
        (final int matchBatchIndex, final List<ScheduleMatch> matchBatch) =>
            matchBatch
                .map(
                  (final ScheduleMatch match) => match.redAlliance
                      .followedBy(match.blueAlliance)
                      .mapIndexed(
                        (final int teamIndex, final LightTeam team) =>
                            ScoutingShift(
                          name: scoutingBatches[matchBatchIndex %
                              scoutingBatches.length][teamIndex % 6],
                          matchIdentifier: match.matchIdentifier,
                          team: team,
                          scheduleId: match.id,
                        ),
                      ),
                )
                .flattened,
      )
      .flattened
      .toList();
}

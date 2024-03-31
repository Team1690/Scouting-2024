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
  final List<ScheduleMatch> matches = MatchesProvider.of(context).matches;
  List<ScoutingShift> shifts = [];
  for (int i = 0; i < scoutingShiftLength; i++) {
    shifts.addAll(
      matches
          .where(
            (element) =>
                element.matchIdentifier.number % scoutingShiftLength == i &&
                element.matchIdentifier.isRematch == false,
          )
          .map(
            (match) =>
                match.blueAlliance.followedBy(match.redAlliance).mapIndexed(
                      (index, team) => ScoutingShift(
                        name: scouters[index],
                        matchIdentifier: match.matchIdentifier,
                        team: team,
                      ),
                    ),
          )
          .flattened,
    );
  }
  return shifts;
}

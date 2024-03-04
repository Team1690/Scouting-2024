import "dart:collection";

import "package:flutter/material.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_teams.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";

Stream<TeamData> fetchSingleTeamData(
  final int id,
  final BuildContext context,
) =>
    fetchMultipleTeamData(<int>[id], context)
        .map((final SplayTreeSet<TeamData> event) => event.first);

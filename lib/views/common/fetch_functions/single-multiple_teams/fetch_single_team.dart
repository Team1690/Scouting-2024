import "dart:collection";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/fetch_teams.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";

Future<TeamData> fetchSingleTeamData(final int id) =>
    fetchMultipleTeamData(<int>[id])
        .then((final SplayTreeSet<TeamData> value) => value.first);

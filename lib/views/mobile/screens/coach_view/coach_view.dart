import "dart:collection";
import "package:carousel_slider/carousel_slider.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_teams.dart";
import "package:scouting_frontend/models/matches_provider.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_match_screen.dart";

class CoachView extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final List<ScheduleMatch> matchesWith1690 = MatchesProvider.of(context)
        .matches
        .where(
          (final ScheduleMatch match) =>
              (match.redAlliance
                      .any((final LightTeam team) => team.number == 1690) ||
                  match.blueAlliance
                      .any((final LightTeam team) => team.number == 1690)) &&
              match.matchIdentifier.isRematch != false,
        )
        .toList();
    final List<LightTeam> teamsThatPlayWith1690 = matchesWith1690
        .map(
          (final ScheduleMatch e) =>
              <LightTeam>[...e.blueAlliance, ...e.redAlliance],
        )
        .flattened
        .toList();
    return Scaffold(
      drawer: SideNavBar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Coach"),
      ),
      body: FutureBuilder<SplayTreeSet<TeamData>>(
        future: fetchMultipleTeamData(
          teamsThatPlayWith1690.map((final LightTeam e) => e.id).toList(),
          context,
        ),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<SplayTreeSet<TeamData>> snapshot,
        ) =>
            snapshot.mapSnapshot(
          onSuccess: (final SplayTreeSet<TeamData> teams) => CarouselSlider(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              height: double.infinity,
              aspectRatio: 2.0,
              viewportFraction: 1,
            ),
            items: matchesWith1690
                .map(
                  (final ScheduleMatch e) => CoachMatchScreen(
                    match: e,
                    blueAllianceTeams: teams
                        .where(
                          (final TeamData teamData) => teamData.matches.any(
                            (final MatchData matchData) =>
                                matchData.scheduleMatch == e &&
                                matchData.scheduleMatch.blueAlliance
                                    .contains(teamData.lightTeam),
                          ),
                        )
                        .toList(),
                    redAllianceTeams: teams
                        .where(
                          (final TeamData teamData) => teamData.matches.any(
                            (final MatchData matchData) =>
                                matchData.scheduleMatch == e &&
                                matchData.scheduleMatch.redAlliance
                                    .contains(teamData.lightTeam),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
          onWaiting: () => const Center(
            child: CircularProgressIndicator(),
          ),
          onNoData: () => const Center(
            child: Text("No Data"),
          ),
          onError: (final Object error) => Text(snapshot.error.toString()),
        ),
      ),
    );
  }
}

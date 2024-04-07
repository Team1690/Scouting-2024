import "dart:collection";
import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_teams.dart";
import "package:scouting_frontend/models/providers/matches_provider.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_match_screen.dart";

class CoachView extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => Scaffold(
        drawer: SideNavBar(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Coach"),
        ),
        body: StreamBuilder<SplayTreeSet<TeamData>>(
          stream: fetchMultipleTeamData(
            MatchesProvider.teamsWith(1690, context)
                .map((final LightTeam e) => e.id)
                .toList(),
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
                initialPage: MatchesProvider.matchesWith(1690, context)
                    .map((final ScheduleMatch e) => e.happened)
                    .indexed
                    .firstWhere(
                      (final (int, bool) team) => !team.$2,
                      orElse: () => (0, false),
                    )
                    .$1,
              ),
              items: MatchesProvider.matchesWith(1690, context)
                  .map(
                    (final ScheduleMatch match) => CoachMatchScreen(
                      match: match,
                      blueAllianceTeams: teams
                          .where(
                            (final TeamData teamData) => teamData.matches.any(
                              (final MatchData matchData) =>
                                  matchData.scheduleMatch == match &&
                                  matchData.scheduleMatch.blueAlliance
                                      .contains(teamData.lightTeam),
                            ),
                          )
                          .toList(),
                      redAllianceTeams: teams
                          .where(
                            (final TeamData teamData) => teamData.matches.any(
                              (final MatchData matchData) =>
                                  matchData.scheduleMatch == match &&
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

import "package:flutter/material.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/fetch_matches.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/matches/change_match.dart";
import "package:scouting_frontend/views/pc/matches/delete.dart";
import "package:scouting_frontend/views/pc/team_info/team_info_screen.dart";

class MatchesScreen extends StatelessWidget {
  const MatchesScreen();

  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: DashboardCard(
            title: "Matches",
            titleWidgets: <Widget>[
              IconButton(
                onPressed: () async {
                  (await showDialog<ScheduleMatch>(
                    context: context,
                    builder: ((final BuildContext dialogContext) =>
                        const ChangeMatch()),
                  ));
                },
                icon: const Icon(Icons.add_circle_outline_outlined),
              ),
            ],
            body: StreamBuilder<List<ScheduleMatch>>(
              stream:
                  fetchMatchesSubscription(IdProvider.of(context).matchType),
              builder: (
                final BuildContext context,
                final AsyncSnapshot<List<ScheduleMatch>> snapshot,
              ) =>
                  snapshot.mapSnapshot(
                onWaiting: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                onError: (final Object error) => Text(error.toString()),
                onNoData: () => const Center(
                  child: Text("No data"),
                ),
                onSuccess: (final List<ScheduleMatch> data) => ListView(
                  children: data
                      .where(
                        (final ScheduleMatch e) => !e.matchIdentifier.isRematch,
                      )
                      .map(
                        (final ScheduleMatch e) => Card(
                          color: bgColor,
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    style: TextStyle(
                                      color: e.happened
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                    "${e.matchIdentifier.type.title} ${e.matchIdentifier.number}",
                                  ),
                                ),
                                ...e.blueAlliance.map(
                                  (final LightTeam currentTeam) => Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute<TeamInfoScreen>(
                                          builder: (
                                            final BuildContext context,
                                          ) =>
                                              TeamInfoScreen(
                                            initialTeam: currentTeam,
                                          ),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                          secondaryColor,
                                        ),
                                      ),
                                      child: Text(
                                        currentTeam.number.toString(),
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ...e.redAlliance.map(
                                  (final LightTeam currentTeam) => Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute<TeamInfoScreen>(
                                          builder:
                                              (final BuildContext context) =>
                                                  TeamInfoScreen(
                                            initialTeam: currentTeam,
                                          ),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                          secondaryColor,
                                        ),
                                      ),
                                      child: Text(
                                        currentTeam.number.toString(),
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    (await showDialog<ScheduleMatch>(
                                      context: context,
                                      builder:
                                          (final BuildContext dialogContext) =>
                                              ChangeMatch(
                                        e,
                                      ),
                                    ));
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    delete(context, e.id, deleteMatch);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      );
}

const String deleteMatch = """
mutation DeleteMatch(\$id: Int!){
  delete_schedule_matches_by_pk(id: \$id){
  	id
  }
}""";

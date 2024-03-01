import "dart:collection";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_teams.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/status/new_status_list.dart";
import "package:scouting_frontend/views/pc/status/widgets/status_box.dart";

class Status extends StatefulWidget {
  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  bool isSpecific = false;

  bool isPreScouting = false;

  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: StreamBuilder<SplayTreeSet<TeamData>>(
          stream: fetchMultipleTeamData(
            TeamProvider.of(context)
                .teams
                .map((final LightTeam team) => team.id)
                .toList(),
            context,
          ),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<SplayTreeSet<TeamData>> snapshot,
          ) =>
              snapshot.mapSnapshot(
            onSuccess: (final SplayTreeSet<TeamData> data) => Center(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: ToggleButtons(
                          children: const <Widget>[
                            Text("Technical"),
                            Text("Specific"),
                            Text("Pre Scouting"),
                          ],
                          isSelected: <bool>[
                            !isSpecific,
                            isSpecific,
                            isPreScouting,
                          ],
                          onPressed: (final int index) {
                            setState(() {
                              switch (index) {
                                case 0:
                                  isSpecific = false;
                                  break;
                                case 1:
                                  isSpecific = true;
                                  break;
                                case 2:
                                  isPreScouting = !isPreScouting;
                                  break;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: StatusList<Object>(
                      data: data
                          .map((final TeamData element) => element.matches)
                          .map(
                            (final List<MatchData> e) => isSpecific
                                ? e.specificMatches
                                : e.technicalMatchExists,
                          )
                          .flattened
                          .toList(),
                      groupBy: (final MatchData matchData) => isPreScouting
                          ? matchData.team
                          : matchData.scheduleMatch.matchIdentifier,
                      orderBy: (final MatchData p0, final MatchData p1) => p1
                          .scheduleMatch.matchIdentifier.number
                          .compareTo(p0.scheduleMatch.matchIdentifier.number),
                      leading: (final List<MatchData> row) => Text(
                        row.first.scheduleMatch.matchIdentifier.toString(),
                      ),
                      statusBoxBuilder: (final MatchData data) => StatusBox(
                        backgroundColor:
                            data.scheduleMatch.blueAlliance.contains(data.team)
                                ? Colors.blue
                                : Colors.red,
                        child: Column(
                          children: <Widget>[
                            Text(data.team.number.toString()),
                            Text(
                              isSpecific
                                  ? data.specificMatchData!.scouterName
                                  : data.technicalMatchData!.scouterName,
                            ),
                            if (!isSpecific)
                              Text(
                                data.technicalMatchData!.data.gamePiecesPoints
                                    .toString(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onWaiting: () => const Center(
              child: CircularProgressIndicator(),
            ),
            onNoData: () => const Text(":("),
            onError: (final Object error) => Text(error.toString()),
          ),
        ),
      );
}

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/matches_provider.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/status/new_status_list.dart";
import "package:scouting_frontend/views/pc/status/widgets/status_box.dart";

class StatusCard extends StatefulWidget {
  const StatusCard({super.key, required this.data});

  final List<TeamData> data;
  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  bool isSpecific = false;
  bool isPreScouting = false;
  @override
  Widget build(final BuildContext context) => Center(
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
                data: widget.data
                    .map((final TeamData element) => element.matches)
                    .flattened
                    .toList(),
                groupBy: (final MatchData matchData) => isPreScouting
                    ? matchData.team
                    : matchData.scheduleMatch.matchIdentifier,
                orderByCompare: (final MatchData p0, final MatchData p1) => p1
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
                      Text(
                        data.team.number.toString(),
                        style: TextStyle(color: Colors.amber),
                      ),
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
                missingStatusBoxBuilder: (final MatchData matchData) =>
                    StatusBox(child: Text(matchData.team.number.toString())),
                isMissingValidator: (final MatchData matchData) =>
                    (matchData.technicalMatchData == null && !isSpecific) ||
                    (matchData.specificMatchData == null && isSpecific),
              ),
            ),
          ],
        ),
      );
}

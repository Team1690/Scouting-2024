import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/status/edit_technical_match.dart";
import "package:scouting_frontend/views/pc/status/widgets/status_list.dart";
import "package:scouting_frontend/views/pc/status/widgets/status_box.dart";
import "package:scouting_frontend/views/pc/team_info/team_info_screen.dart";

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.data});

  final List<TeamData> data;
  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  bool isSpecific = false;
  bool isPreScouting = false;
  @override
  Widget build(final BuildContext context) => Card(
        color: bgColor,
        elevation: 2,
        margin: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding / 2,
                    ),
                    child: ToggleButtons(
                      children: const <Widget>[
                        Text("Technical"),
                        Text("Specific"),
                        Text("Pre Scouting"),
                      ]
                          .map(
                            (final Widget e) => Padding(
                              padding: const EdgeInsets.all(defaultPadding / 2),
                              child: e,
                            ),
                          )
                          .toList(),
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
                child: StatusList<Object, MatchData>(
                  data: widget.data
                      .map((final TeamData e) => e.matches)
                      .flattened
                      .where(
                        (final MatchData element) =>
                            element.scheduleMatch.matchIdentifier.type ==
                                MatchType.pre ||
                            !isPreScouting,
                      )
                      .toList(),
                  groupBy: (final MatchData matchData) => isPreScouting
                      ? matchData.team
                      : matchData.scheduleMatch.matchIdentifier,
                  orderByCompare: (final MatchData p0, final MatchData p1) =>
                      isPreScouting
                          ? p0.team.number.compareTo(p1.team.number)
                          : p1.scheduleMatch.matchIdentifier.number.compareTo(
                              p0.scheduleMatch.matchIdentifier.number,
                            ),
                  leading: (final List<MatchData> row) => Text(
                    isPreScouting
                        ? "${row.first.team.number.toString()} ${row.first.team.name}"
                        : row.first.scheduleMatch.matchIdentifier.toString(),
                  ),
                  statusBoxBuilder: (final MatchData data) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (final BuildContext context) =>
                              TeamInfoScreen(initialTeam: data.team),
                        ),
                      );
                    },
                    onDoubleTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (final BuildContext context) =>
                              EditTechnicalMatch(
                            match: data.scheduleMatch,
                            teamForQuery: data.team,
                          ),
                        ),
                      );
                    },
                    child: StatusBox(
                      child: Column(
                        children: <Widget>[
                          Text(
                            data.team.number.toString(),
                            style: TextStyle(
                              color: data.isBlueAlliance
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          ),
                          Text(
                            isSpecific
                                ? data.specificMatchData!.scouterName
                                : data.technicalMatchData!.scouterName,
                            style: TextStyle(
                              color: data.isBlueAlliance
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          ),
                          if (!isSpecific)
                            Text(
                              data.technicalMatchData!.data.gamePiecesPoints
                                  .toString(),
                              style: TextStyle(
                                color: data.isBlueAlliance
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  missingStatusBoxBuilder: (final MatchData matchData) =>
                      StatusBox(
                    backgroundColor:
                        matchData.isBlueAlliance ? Colors.blue : Colors.red,
                    child: Text(
                      matchData.team.number.toString(),
                    ),
                  ),
                  isMissingValidator: (final MatchData matchData) =>
                      ((matchData.technicalMatchData == null && !isSpecific) ||
                          (matchData.specificMatchData == null && isSpecific)),
                  orderRowByCompare: (final MatchData p0, final MatchData p1) =>
                      p0.isBlueAlliance && !p1.isBlueAlliance ? 1 : -1,
                ),
              ),
            ],
          ),
        ),
      );
}

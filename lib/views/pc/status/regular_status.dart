import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/status/edit_technical_match.dart";
import "package:scouting_frontend/views/pc/status/fetch_status.dart";
import "package:scouting_frontend/views/pc/status/status_match.dart";
import "package:scouting_frontend/views/pc/status/status_screen.dart";
import "package:scouting_frontend/views/pc/status/widgets/text_by_team.dart";
import "package:scouting_frontend/views/pc/team_info/team_info_screen.dart";

import "status_item.dart";
import "status_list.dart";

class RegularStatus extends StatelessWidget {
  const RegularStatus(this.isSpecific);

  final bool isSpecific;

  @override
  Widget build(final BuildContext context) =>
      StreamBuilder<List<StatusItem<MatchIdentifier, StatusMatch>>>(
        stream: fetchStatus(isSpecific, context),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<List<StatusItem<MatchIdentifier, StatusMatch>>>
              snapshot,
        ) =>
            snapshot.mapSnapshot<Widget>(
          onError: (final Object? error) => Text(error.toString()),
          onNoData: () => throw Exception("No data"),
          onSuccess:
              (final List<StatusItem<MatchIdentifier, StatusMatch>> matches) =>
                  StatusList<MatchIdentifier, StatusMatch>(
            validateSpecificValue: (
              final StatusMatch scoutedMatch,
              final StatusItem<MatchIdentifier, StatusMatch> statusItem,
            ) =>
                scoutedMatch.scoutedTeam.alliancePos != -1 ? null : Colors.red,
            missingBuilder: (final StatusMatch scoutedMatch) =>
                Text(scoutedMatch.scoutedTeam.team.number.toString()),
            getTitle:
                (final StatusItem<MatchIdentifier, StatusMatch> statusItem) =>
                    Column(
              children: <Widget>[
                Text(
                  "${statusItem.identifier.isRematch ? "Re\n " : ""}${statusItem.identifier.type.title} ${statusItem.identifier.number}",
                ),
                if (!isSpecific)
                  Row(
                    children: <Widget>[
                      Text(
                        style: const TextStyle(color: Colors.blue),
                        "${statusItem.values.where((final StatusMatch scoutedMatch) => scoutedMatch.scoutedTeam.allianceColor == Colors.blue).map((final StatusMatch scoutedMatch) => scoutedMatch.scoutedTeam.points).fold<int>(0, (final int previousValue, final int currentValue) => previousValue + currentValue)}",
                      ),
                      const Text(" - "),
                      Text(
                        style: const TextStyle(color: Colors.red),
                        "${statusItem.values.where((final StatusMatch scoutedMatch) => scoutedMatch.scoutedTeam.allianceColor == Colors.red).map((final StatusMatch scoutedMatch) => scoutedMatch.scoutedTeam.points).fold<int>(0, (final int sumUntilNow, final int currentValue) => sumUntilNow + currentValue)}",
                      ),
                    ],
                  ),
              ],
            ),
            getValueBox: (
              final StatusMatch scoutedMatch,
              final StatusItem<MatchIdentifier, StatusMatch> item,
            ) =>
                GestureDetector(
              onLongPress: () {
                if (!isSpecific) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<TeamInfoScreen>(
                      builder: (final BuildContext context) =>
                          EditTechnicalMatch(
                        matchIdentifier: item.identifier,
                        teamForQuery: scoutedMatch.scoutedTeam.team,
                      ),
                    ),
                  );
                }
              },
              onTap: (() => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<TeamInfoScreen>(
                      builder: (final BuildContext context) => TeamInfoScreen(
                        initalTeam: scoutedMatch.scoutedTeam.team,
                      ),
                    ),
                  )),
              child: Column(
                children: <Widget>[
                  TextByTeam(
                    match: scoutedMatch,
                    text: scoutedMatch.scoutedTeam.team.number.toString(),
                  ),
                  TextByTeam(
                    match: scoutedMatch,
                    text: scoutedMatch.scouter,
                  ),
                  if (!isSpecific)
                    TextByTeam(
                      match: scoutedMatch,
                      text: scoutedMatch.scoutedTeam.points.toString(),
                    ),
                ],
              ),
            ),
            items: matches.reversed.toList()
              ..forEach(
                (final StatusItem<MatchIdentifier, StatusMatch> statusItem) =>
                    statusItem.values.sort(
                  (
                    final StatusMatch scoutedMatchA,
                    final StatusMatch scoutedMatchB,
                  ) =>
                      scoutedMatchA.scoutedTeam.allianceColor ==
                              scoutedMatchB.scoutedTeam.allianceColor
                          ? 0
                          : (scoutedMatchA.scoutedTeam.allianceColor ==
                                  Colors.red
                              ? 1
                              : -1),
                ),
              ),
            validate: always2(true),
          ),
          onWaiting: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}

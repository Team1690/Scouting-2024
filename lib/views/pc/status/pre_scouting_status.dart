import "package:flutter/material.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/status/fetch_status.dart";
import "package:scouting_frontend/views/pc/status/status_item.dart";
import "package:scouting_frontend/views/pc/status/status_list.dart";

class PreScoutingStatus extends StatelessWidget {
  const PreScoutingStatus(this.isSpecific);
  final bool isSpecific;
  @override
  Widget build(final BuildContext context) =>
      StreamBuilder<List<StatusItem<LightTeam, String>>>(
        stream: fetchPreScoutingStatus(isSpecific),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<List<StatusItem<LightTeam, String>>> snapshot,
        ) =>
            snapshot.mapSnapshot<Widget>(
          onError: (final Object? error) => Text(error.toString()),
          onNoData: () => throw Exception("No data"),
          onSuccess: (final List<StatusItem<LightTeam, String>> matches) {
            final List<StatusItem<LightTeam, String>> teamsNotInData =
                TeamProvider.of(context)
                    .teams
                    .where(
                      (final LightTeam team) => !matches
                          .map(
                            (final StatusItem<LightTeam, String> statusItem) =>
                                statusItem.identifier,
                          )
                          .contains(team),
                    )
                    .map(
                      (final LightTeam e) => StatusItem<LightTeam, String>(
                        identifier: e,
                        values: <String>[],
                        missingValues: <String>[],
                      ),
                    )
                    .toList();

            return StatusList<LightTeam, String>(
              validateSpecificValue: (final _, final __) => null,
              pushUnvalidatedToTheTop: true,
              getTitle: (final StatusItem<LightTeam, String> statusItem) =>
                  Text(
                "${statusItem.identifier.number} ${statusItem.identifier.name}",
              ),
              getValueBox: (
                final String scouter,
                final StatusItem<LightTeam, String> item,
              ) =>
                  Text(
                scouter,
              ),
              items: matches..addAll(teamsNotInData),
              validate: (final StatusItem<LightTeam, String> statusItem) =>
                  statusItem.values.length == 4,
            );
          },
          onWaiting: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}

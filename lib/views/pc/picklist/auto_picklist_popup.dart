import "dart:math";
import "package:flutter/material.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/fetch_functions/all_teams/all_team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/all_teams/fetch_all_teams.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/auto_picklist/value_sliders.dart";

class AutoPickListPopUp extends StatefulWidget {
  const AutoPickListPopUp({
    super.key,
    required this.onReorder,
    required this.teamsToSort,
  });
  final void Function(List<AllTeamData>) onReorder;
  final List<AllTeamData> teamsToSort;
  @override
  State<AutoPickListPopUp> createState() => _AutoPickListPopUpState();
}

class _AutoPickListPopUpState extends State<AutoPickListPopUp> {
  bool hasValues = false;
  double speakerFactor = 0.5;
  double ampFactor = 0.5;
  double climbFactor = 0.5;
  double trapFactor = 0.5;
  bool filter = false;

  @override
  Widget build(final BuildContext context) => AlertDialog(
        content: Column(
          children: <Widget>[
            ValueSliders(
              onButtonPress: (
                final double climbSlider,
                final double ampSlider,
                final double speakerSlider,
                final double trapSlider,
                final bool feeder,
              ) =>
                  setState(() {
                hasValues = true;
                climbFactor = 1 - climbSlider;
                ampFactor = 1 - ampSlider;
                speakerFactor = 1 - speakerSlider;
                trapFactor = 1 - trapSlider;
                filter = feeder;
                final List<AllTeamData> teamsList = widget.teamsToSort;
                hasValues
                  ? Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: StreamBuilder<List<AllTeamData>>(
                        stream: fetchAllTeams(),
                        builder: (
                          final BuildContext context,
                          final AsyncSnapshot<List<AllTeamData>> snapshot,
                        ) =>
                            snapshot.mapSnapshot(
                          onSuccess: (final List<AllTeamData> teams) {
                            final List<AllTeamData> teamsList = snapshot.data!;
                            final double maxAmp = teamsList
                                    .map(
                                      (final AllTeamData e) =>
                                          e.aggregateData.avgAutoAmp,
                                    )
                                    .fold(0.0, max) +
                                teamsList
                                    .map(
                                      (final AllTeamData e) =>
                                          e.aggregateData.avgTeleAmp,
                                    )
                                    .fold(0.0, max);
                            final double maxSpeaker = teamsList
                                    .map(
                                      (final AllTeamData e) =>
                                          e.aggregateData.avgAutoSpeaker,
                                    )
                                    .fold(0.0, max) +
                                teamsList
                                    .map(
                                      (final AllTeamData e) =>
                                          e.aggregateData.avgTeleSpeaker,
                                    )
                                    .fold(0.0, max);
                teamsList.sort(
                  (
                    final AllTeamData b,
                    final AllTeamData a,
                  ) =>
                      (a.climbedPercentage * climbFactor / 100 +
                              (a.aggregateData.avgAutoAmp +
                                      a.aggregateData.avgTeleAmp) *
                                  ampFactor /
                                  teamsList.fold(
                                    0,
                                    (
                                      final num previousValue,
                                      final AllTeamData element,
                                    ) =>
                                        max(
                                      previousValue,
                                      element.aggregateData.maxAutoAmp,
                                    ),
                                  ) +
                              (a.aggregateData.avgAutoSpeaker +
                                      a.aggregateData.avgTeleSpeaker) *
                                  speakerFactor /
                                  teamsList.fold(
                                    0,
                                    (
                                      final num previousValue,
                                      final AllTeamData element,
                                    ) =>
                                        max(
                                      previousValue,
                                      element.aggregateData.maxAutoSpeaker,
                                    ),
                                  ) +
                              a.aggregateData.avgTrapAmount * trapFactor / 2)
                          .compareTo(
                    b.climbedPercentage * climbFactor / 100 +
                        (b.aggregateData.avgAutoAmp +
                                b.aggregateData.avgTeleAmp) *
                            ampFactor /
                            teamsList.fold(
                              0,
                              (
                                final num previousValue,
                                final AllTeamData element,
                              ) =>
                                  max(
                                previousValue,
                                element.aggregateData.maxAutoAmp,
                              ),
                            ) +
                        (b.aggregateData.avgAutoSpeaker +
                                b.aggregateData.avgTeleSpeaker) *
                            speakerFactor /
                            teamsList.fold(
                              0,
                              (
                                final num previousValue,
                                final AllTeamData element,
                              ) =>
                                  max(
                                previousValue,
                                element.aggregateData.maxAutoSpeaker,
                              ),
                            ) +
                        b.aggregateData.avgTrapAmount * trapFactor / 2,
                  ),
                );
                widget.onReorder(teamsList);
              }),
            ),

                          onWaiting: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          onNoData: () => const Center(
                            child: Text("No Teams"),
                          ),
                          onError: (final Object error) =>
                              Text(snapshot.error.toString()),
                        ),
                      ),
                    )
                  : Container(),
          ],
        ),
      );
}

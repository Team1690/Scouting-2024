import "dart:math";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/fetch_functions/all_teams/all_team_data.dart";
import "package:scouting_frontend/views/pc/auto_picklist/value_sliders.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_screen.dart";

class AutoPickListPopUp extends StatefulWidget {
  const AutoPickListPopUp(
      {super.key, required this.teamsToSort, required this.currentPickList});
  final List<AllTeamData> teamsToSort;
  final CurrentPickList currentPickList;
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

  double calculateValue(final AllTeamData val) {
    final List<AllTeamData> teamsList = widget.teamsToSort;
    return (val.climbedPercentage * climbFactor / 100 +
        (val.aggregateData.avgAutoAmp + val.aggregateData.avgTeleAmp) *
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
        (val.aggregateData.avgAutoSpeaker + val.aggregateData.avgTeleSpeaker) *
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
        val.aggregateData.avgTrapAmount * trapFactor / 2);
  }

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
                final List<AllTeamData> newSortedTeamList =
                    widget.teamsToSort.sorted(
                  (
                    final AllTeamData b,
                    final AllTeamData a,
                  ) =>
                      calculateValue(a).compareTo(
                    calculateValue(b),
                  ),
                );

                newSortedTeamList
                    .forEachIndexed((final int index, final AllTeamData team) {
                  widget.currentPickList.setIndex(team, index);
                });

                Navigator.pop(context, newSortedTeamList);
              }),
            ),
          ],
        ),
      );
}

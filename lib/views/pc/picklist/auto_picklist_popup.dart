import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_data/all_team_data.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_screen.dart";
import "package:scouting_frontend/views/pc/picklist/value_sliders.dart";

class AutoPickListPopUp extends StatefulWidget {
  const AutoPickListPopUp({
    super.key,
    required this.teamsToSort,
    required this.currentPickList,
  });
  final List<AllTeamData> teamsToSort;
  final CurrentPickList currentPickList;
  @override
  State<AutoPickListPopUp> createState() => _AutoPickListPopUpState();
}

class _AutoPickListPopUpState extends State<AutoPickListPopUp> {
  double speakerFactor = 0.5;
  double ampFactor = 0.5;
  double climbFactor = 0.5;
  double trapFactor = 0.5;

  double calculateValue(final AllTeamData val) {
    final List<AllTeamData> teamsList = widget.teamsToSort;
    final double result = (val.climbPercentage * climbFactor / 100 +
            (val.aggregateData.avgData.ampGamepieces) *
                ampFactor /
                teamsList
                    .map(
                      (final AllTeamData e) =>
                          e.aggregateData.avgData.ampGamepieces,
                    )
                    .whereNot((final double element) => element.isNaN)
                    .max) +
        (val.aggregateData.avgData.speakerGamepieces) *
            speakerFactor /
            teamsList
                .map(
                  (final AllTeamData e) =>
                      e.aggregateData.avgData.speakerGamepieces,
                )
                .whereNot((final double element) => element.isNaN)
                .max +
        val.aggregateData.avgData.trapAmount * trapFactor / 2;
    return result.isFinite ? result : double.negativeInfinity;
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
              ) =>
                  setState(() {
                climbFactor = climbSlider;
                ampFactor = ampSlider;
                speakerFactor = speakerSlider;
                trapFactor = trapSlider;
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

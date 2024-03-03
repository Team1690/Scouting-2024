import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_screen.dart";
import "package:scouting_frontend/views/pc/picklist/value_sliders.dart";

typedef AutoPicklistResult = ({
  double climbFactor,
  double ampFactor,
  double speakerFactor,
  bool filterSwerve,
});

class AutoPickListPopUp extends StatelessWidget {
  const AutoPickListPopUp({
    super.key,
    required this.teamsToSort,
    required this.currentPickList,
  });
  final List<AllTeamData> teamsToSort;
  final CurrentPickList currentPickList;

  double calculateValue(
    final AllTeamData val,
    final AutoPicklistResult request,
  ) {
    final List<AllTeamData> teamsList = teamsToSort;

    if (request.filterSwerve &&
        val.pitData?.driveTrainType == DriveTrain.swerve) {
      return double.negativeInfinity;
    }

    final double result = (val.climbPercentage * request.climbFactor / 100 +
            (val.aggregateData.avgData.ampGamepieces) *
                request.ampFactor /
                teamsList
                    .map(
                      (final AllTeamData e) =>
                          e.aggregateData.avgData.ampGamepieces,
                    )
                    .whereNot((final double element) => element.isNaN)
                    .max) +
        (val.aggregateData.avgData.speakerGamepieces) *
            request.speakerFactor /
            teamsList
                .map(
                  (final AllTeamData e) =>
                      e.aggregateData.avgData.speakerGamepieces,
                )
                .whereNot((final double element) => element.isNaN)
                .max;

    return result.isFinite ? result : double.negativeInfinity;
  }

  @override
  Widget build(final BuildContext context) => AlertDialog(
        content: Column(
          children: <Widget>[
            ValueSliders(
              onButtonPress: (final AutoPicklistResult request) {
                final List<AllTeamData> newSortedTeamList = teamsToSort.sorted(
                  (
                    final AllTeamData b,
                    final AllTeamData a,
                  ) =>
                      calculateValue(a, request).compareTo(
                    calculateValue(b, request),
                  ),
                );
                newSortedTeamList
                    .forEachIndexed((final int index, final AllTeamData team) {
                  currentPickList.setIndex(team, index);
                });

                Navigator.pop(context, newSortedTeamList);
              },
            ),
          ],
        ),
      );
}

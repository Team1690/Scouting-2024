import "package:flutter/material.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/gamechart_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/pit_scouting.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/quick_data/quick_data.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/specific_card.dart";
import "package:scouting_frontend/models/team_info_models/quick_data.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";

class TeamInfoData extends StatelessWidget {
  TeamInfoData(this.team);
  final LightTeam team;

  @override
  Widget build(final BuildContext context) => FutureBuilder<TeamData>(
        future: fetchSingleTeamData(team.id, context),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<TeamData> snapShot,
        ) =>
            snapShot.mapSnapshot(
          onSuccess: (final TeamData data) => Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: QuickDataCard(getQuickdata(data)),
                    ),
                    const SizedBox(height: defaultPadding),
                    Expanded(
                      flex: 6,
                      child: Gamechart(data),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                flex: 2,
                child: SpecificCard(
                  matchData: data.matches,
                  summaryData: data.summaryData,
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                flex: 2,
                child: PitScouting(data),
              ),
            ],
          ),
          onWaiting: () => const Center(
            child: CircularProgressIndicator(),
          ),
          onNoData: () => const Text("No data available"),
          onError: (final Object error) =>
              Center(child: Text(snapShot.error.toString())),
        ),
      );
}

QuickData getQuickdata(final TeamData data) => QuickData(
      medianData: data.aggregateData.medianData,
      maxData: data.aggregateData.maxData,
      minData: data.aggregateData.minData,
      amoutOfMatches: data.technicalMatches.length,
      firstPicklistIndex: data.firstPicklistIndex,
      secondPicklistIndex: data.secondPicklistIndex,
      thirdPicklistIndex: data.thirdPicklistIndex,
      canHarmony: data.pitData?.harmony,
      climbPercentage: data.climbPercentage,
      matchesClimbedSingle: data.technicalMatches
          .where(
            (final TechnicalMatchData element) =>
                element.robotFieldStatus == RobotFieldStatus.worked &&
                element.harmonyWith == 0,
          )
          .length,
      matchesClimbedDouble: data.technicalMatches
          .where((final TechnicalMatchData element) => element.harmonyWith == 1)
          .length,
      matchesClimbedTriple: data.technicalMatches
          .where((final TechnicalMatchData element) => element.harmonyWith == 2)
          .length,
      gamepiecePoints: data.aggregateData.avgData.gamePiecesPoints,
      gamepiecesScored: data.aggregateData.avgData.gamepieces,
      trapAmount: data.pitData?.trap,
      avgData: data.aggregateData.avgData,
      //TODO: add to getters
      trapSuccessRate: 0,
    );

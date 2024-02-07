import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
import "package:scouting_frontend/models/team_data/specific_match_data.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/gamechart_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/pit_scouting.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/quick_data/quick_data.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/specific_card.dart";
import "package:scouting_frontend/models/enums/defense_amount_enum.dart";
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
      amoutOfMatches: data.technicalMatches.length,
      firstPicklistIndex: data.firstPicklistIndex,
      secondPicklistIndex: data.secondPicklistIndex,
      thirdPicklistIndex: data.thirdPicklistIndex,
      autoAmpAvg: data.aggregateData.avgData.autoAmp,
      teleAmpAvg: data.aggregateData.avgData.teleAmp,
      bestAmpGamepiecesSum:
          //TODO: proper max in aggregate data
          data.aggregateData.maxData.autoAmp +
              data.aggregateData.maxData.teleAmp,
      autoSpeakerAvg: data.aggregateData.avgData.autoSpeaker,
      teleSpeakerAvg: data.aggregateData.avgData.teleSpeaker,
      bestSpeakerGamepiecesSum: data.aggregateData.maxData.autoSpeaker +
          data.aggregateData.maxData.teleSpeaker,
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
      avgAutoSpeakerMissed: data.aggregateData.avgData.autoSpeakerMissed,
      avgTeleSpeakerMissed: data.aggregateData.avgData.teleSpeakerMissed,
      trapAmount: data.pitData?.trap,
      avgTrapAmount: data.aggregateData.avgData.trapAmount,
      avgGamepiecesNoDefense: data.matches.fullGames
              .where((final MatchData match) =>
                  match.specificMatchData!.defenseAmount ==
                  DefenseAmount.noDefense)
              .map((final MatchData match) =>
                  match.technicalMatchData!.data.gamepieces)
              .toList()
              .averageOrNull ??
          double.nan,
      avgGamepiecesFullDefense: data.matches.fullGames
              .where((final MatchData match) =>
                  match.specificMatchData!.defenseAmount ==
                  DefenseAmount.fullDefense)
              .map((final MatchData match) =>
                  match.technicalMatchData!.data.gamepieces)
              .toList()
              .averageOrNull ??
          double.nan,
      avgGamepiecesHalfDefense: data.matches.fullGames
              .where((final MatchData match) =>
                  match.specificMatchData!.defenseAmount ==
                  DefenseAmount.halfDefense)
              .map((final MatchData match) =>
                  match.technicalMatchData!.data.gamepieces)
              .toList()
              .averageOrNull ??
          double.nan,
      //TODO: add to getters
      trapSuccessRate: 0,
    );

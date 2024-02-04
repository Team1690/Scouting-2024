import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/fetch_functions/climb_enum.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/fetch_single_team.dart";
import "package:scouting_frontend/views/common/fetch_functions/single-multiple_teams/team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_match_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/gamechart_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/quick_data/quick_data.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/specific_card.dart";

class TeamInfoData extends StatelessWidget {
  TeamInfoData(this.team);
  final LightTeam team;

  @override
  Widget build(final BuildContext context) => FutureBuilder<TeamData>(
        future: fetchSingleTeamData(team.id),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<TeamData> snapShot,
        ) {
          if (snapShot.hasError) {
            return Center(child: Text(snapShot.error.toString()));
          } else if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapShot.data.mapNullable<Widget>(
                (final TeamData data) => Row(
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
                        matchData: data.specificMatches,
                        summaryData: data.summaryData,
                      ),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    // Expanded(
                    //   flex: 2,
                    //   child: PitScouting(data.pitViewData),
                    // ),
                  ],
                ),
              ) ??
              const Text("No data available");
        },
      );
}

QuickData getQuickdata(final TeamData data) => QuickData(
      amoutOfMatches: data.technicalMatches.length,
      firstPicklistIndex: data.firstPicklistIndex,
      secondPicklistIndex: data.secondPicklistIndex,
      thirdPicklistIndex: data.thirdPicklistIndex,
      autoAmpAvg: data.aggregateData.avgAutoAmp,
      teleAmpAvg: data.aggregateData.avgTeleAmp,
      bestAmpGamepiecesSum:
          data.aggregateData.maxAutoAmp + data.aggregateData.maxTeleAmp,
      autoSpeakerAvg: data.aggregateData.avgAutoSpeaker,
      teleSpeakerAvg: data.aggregateData.avgTeleSpeaker,
      bestSpeakerGamepiecesSum:
          data.aggregateData.maxAutoSpeaker + data.aggregateData.maxTeleSpeaker,
      canHarmony: data.pitData?.harmony,
      climbPercentage: data.technicalMatches
              .where(
                (final TechnicalMatchData element) =>
                    element.climb.title != Climb.noAttempt.title,
              )
              .isNotEmpty
          ? data.technicalMatches
                  .where(
                    (final TechnicalMatchData element) =>
                        element.climb.title == Climb.climbed.title ||
                        element.climb.title == Climb.buddyClimbed.title,
                  )
                  .length /
              data.technicalMatches
                  .where(
                    (final TechnicalMatchData element) =>
                        element.climb.title != Climb.noAttempt.title,
                  )
                  .length *
              100
          : double.nan,
      matchesClimbedSingle: data.technicalMatches
          .where(
            (final TechnicalMatchData element) =>
                element.robotFieldStatus.name == RobotFieldStatus.worked.name &&
                element.harmonyWith == 0,
          )
          .length,
      matchesClimbedDouble: data.technicalMatches
          .where((final TechnicalMatchData element) => element.harmonyWith == 1)
          .length,
      matchesClimbedTriple: data.technicalMatches
          .where((final TechnicalMatchData element) => element.harmonyWith == 2)
          .length,
      gamepiecePoints: data.technicalMatches
              .map((final TechnicalMatchData e) => e.gamepiecesPoints)
              .toList()
              .averageOrNull ??
          0,
      gamepiecesScored: data.technicalMatches
              .map((final TechnicalMatchData e) => e.gamepieces)
              .toList()
              .averageOrNull ??
          0,
      avgAutoSpeakerMissed: data.aggregateData.avgAutoSpeakerMissed,
      avgTeleSpeakerMissed: data.aggregateData.avgTeleSpeakerMissed,
      trapAmount: data.pitData?.trap,
      avgTrapAmount: data.aggregateData.avgTrapAmount,
      avgGamepiecesNoDefense: data.specificMatches
              .where(
                (final SpecificMatchData? element) =>
                    element != null &&
                    element.defenseAmount == DefenseAmount.noDefense,
              )
              .map(
                (final SpecificMatchData? e) => data.technicalMatches.where(
                  (final TechnicalMatchData technicalMatchData) =>
                      (e?.scheduleMatchId ?? 0) ==
                      technicalMatchData.scheduleMatchId,
                ),
              )
              .firstOrNull
              ?.map((final TechnicalMatchData e) => e.gamepieces)
              .toList()
              .averageOrNull ??
          double.nan,
      avgGamepiecesFullDefense: data.specificMatches
              .where(
                (final SpecificMatchData? element) =>
                    element != null &&
                    element.defenseAmount == DefenseAmount.fullDefense,
              )
              .map(
                (final SpecificMatchData? e) => data.technicalMatches.where(
                  (final TechnicalMatchData technicalMatchData) =>
                      (e?.scheduleMatchId ?? 0) ==
                      technicalMatchData.scheduleMatchId,
                ),
              )
              .firstOrNull
              ?.map((final TechnicalMatchData e) => e.gamepieces)
              .toList()
              .averageOrNull ??
          double.nan,
      avgGamepiecesHalfDefense: data.specificMatches
              .where(
                (final SpecificMatchData? element) =>
                    element != null &&
                    element.defenseAmount == DefenseAmount.halfDefense,
              )
              .map(
                (final SpecificMatchData? e) => data.technicalMatches.where(
                  (final TechnicalMatchData technicalMatchData) =>
                      (e?.scheduleMatchId ?? 0) ==
                      technicalMatchData.scheduleMatchId,
                ),
              )
              .firstOrNull
              ?.map((final TechnicalMatchData e) => e.gamepieces)
              .toList()
              .averageOrNull ??
          double.nan,
      trapSuccessRate: data.technicalMatches
              .where(
                (final TechnicalMatchData e) =>
                    e.trapAmount != 0 || e.trapsMissed != 0,
              )
              .isNotEmpty
          ? data.technicalMatches
                  .map(
                    (final TechnicalMatchData element) =>
                        element.trapAmount != 0,
                  )
                  .length /
              data.technicalMatches
                  .map(
                    (final TechnicalMatchData e) =>
                        e.trapAmount != 0 || e.trapsMissed != 0,
                  )
                  .length *
              100
          : double.nan,
    );

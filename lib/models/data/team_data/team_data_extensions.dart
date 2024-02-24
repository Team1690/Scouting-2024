import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/team_info_models/quick_data.dart";

extension CardGetters on TeamData {
  QuickData get quickData => QuickData(
        medianData: aggregateData.medianData,
        avgData: aggregateData.avgData,
        maxData: aggregateData.maxData,
        minData: aggregateData.minData,
        amoutOfMatches: aggregateData.gamesPlayed,
        firstPicklistIndex: firstPicklistIndex,
        secondPicklistIndex: secondPicklistIndex,
        thirdPicklistIndex: thirdPicklistIndex,
        matchesClimbedSingle: matchesClimbedSingle,
        matchesClimbedDouble: matchesClimbedDouble,
        matchesClimbedTriple: matchesClimbedTriple,
        climbPercentage: climbPercentage,
        canHarmony: pitData?.harmony,
        gamepiecePoints: aggregateData.avgData.gamePiecesPoints,
        gamepiecesScored: aggregateData.avgData.gamepieces,
        trapAmount: aggregateData.sumData.trapAmount,
        trapSuccessRate: trapSuccessRate,
      );
}

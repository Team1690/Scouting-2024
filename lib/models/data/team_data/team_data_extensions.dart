import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/team_info_models/auto_data.dart";
import "package:scouting_frontend/models/team_info_models/quick_data.dart";

extension CardGetters on TeamData {
  QuickData get quickData => QuickData(
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
      );
  AutoData get autoData => AutoData(
        avgData: aggregateData.avgData,
        autos: matches.technicalMatchExists
            .map(
              (final MatchData e) =>
                  (e.scheduleMatch.matchIdentifier, e.technicalMatchData!.auto),
            )
            .toList(),
      );
}

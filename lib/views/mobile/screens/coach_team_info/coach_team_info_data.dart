import "package:flutter/material.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_data/team_match_data.dart";
import "package:scouting_frontend/models/team_info_models/quick_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/mobile/screens/coach_team_info/coach_quick_data.dart";
import "package:scouting_frontend/views/mobile/screens/coach_team_info/coach_team_info_line_charts.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/pit_scouting_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/specific_card.dart";

class CoachTeamData extends StatelessWidget {
  const CoachTeamData(this.team);
  final LightTeam team;
  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "${team.number} ${team.name}",
          ),
        ),
        body: FutureBuilder<TeamData>(
          future: fetchSingleTeamData(
            team.id,
            context,
          ), //fetchTeam(team.id, context),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<TeamData> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return snapshot.data.mapNullable(
                    (final TeamData data) => CarouselWithIndicator(
                      enableInfininteScroll: true,
                      initialPage: 0,
                      widgets: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DashboardCard(
                            title: "Line charts",
                            body: data.aggregateData.gamesPlayed < 2
                                ? const Center(
                                    child: Text("No data :("),
                                  )
                                : CoachTeamInfoLineCharts(data),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DashboardCard(
                            title: "Specific",
                            body: data.matches.specificMatches.isEmpty
                                ? const Center(
                                    child: Text("No data :("),
                                  )
                                : SpecificCard(
                                    matchData: data.matches.specificMatches,
                                    summaryData: data.summaryData,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: DashboardCard(
                            title: "Quick data",
                            body: CoachQuickData(
                              QuickData(
                                medianData: data.aggregateData.medianData,
                                avgData: data.aggregateData.avgData,
                                maxData: data.aggregateData.maxData,
                                minData: data.aggregateData.minData,
                                amoutOfMatches: data.aggregateData.gamesPlayed,
                                firstPicklistIndex: data.firstPicklistIndex,
                                secondPicklistIndex: data.secondPicklistIndex,
                                thirdPicklistIndex: data.thirdPicklistIndex,
                                //TODO: getters...
                                matchesClimbedSingle: 0,
                                matchesClimbedDouble: 0,
                                matchesClimbedTriple: 0,
                                climbPercentage: data.climbPercentage,
                                canHarmony: data.pitData?.harmony,
                                gamepiecePoints:
                                    data.aggregateData.avgData.gamePiecesPoints,
                                gamepiecesScored:
                                    data.aggregateData.avgData.gamepieces,
                                trapAmount:
                                    data.aggregateData.sumData.trapAmount,
                                trapSuccessRate: 0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: data.pitData.mapNullable(
                                PitScoutingCard.new,
                              ) ??
                              const DashboardCard(
                                title: "Pit scouting",
                                body: Center(
                                  child: Text("No data"),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ) ??
                  (throw Exception("No data"));
            }
          },
        ),
      );
}

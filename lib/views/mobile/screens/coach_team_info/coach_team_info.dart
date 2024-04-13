import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data_extensions.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/auto_data/auto_data_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/gamechart_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/pit_scouting_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/quick_data/quick_data_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/specific_card.dart";

class CoachTeamInfo extends StatelessWidget {
  const CoachTeamInfo(this.team);
  final LightTeam team;
  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "${team.number} ${team.name}",
          ),
        ),
        body: StreamBuilder<TeamData>(
          stream: fetchSingleTeamData(
            team.id,
            context,
          ), //fetchTeam(team.id, context),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<TeamData> snapshot,
          ) =>
              snapshot.mapSnapshot(
            onSuccess: (final TeamData data) => CarouselWithIndicator(
              enableInfininteScroll: true,
              initialPage: 0,
              widgets: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Gamechart(
                    data: data,
                    direction: Axis.vertical,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SpecificCard(
                    team: data.lightTeam,
                    matchData: data.matches.specificMatches,
                    summaryData: data.summaryData,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: QuickDataCard(
                    data: data.quickData,
                    direction: Axis.vertical,
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: data.matches.technicalMatchExists.isEmpty
                      ? const DashboardCard(
                          title: "Auto Data",
                          body: Center(
                            child: Text("No data"),
                          ),
                        )
                      : AutoDataCard(data: data.autoData),
                ),
              ],
            ),
            onWaiting: () => const Center(
              child: CircularProgressIndicator(),
            ),
            onNoData: () => const Center(
              child: Text("No data"),
            ),
            onError: (final Object error) => Text(snapshot.error.toString()),
          ),
        ),
      );
}

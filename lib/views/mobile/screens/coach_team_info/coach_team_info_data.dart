import "package:flutter/material.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

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
                      widgets: const <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: DashboardCard(
                        //     title: "Line charts",
                        //     body: data.quickData.amoutOfMatches < 2
                        //         ? const Center(
                        //             child: Text("No data :("),
                        //           )
                        //         : CoachTeamInfoLineCharts(data),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: DashboardCard(
                        //     title: "Specific",
                        //     body: data.specificData.msg.isEmpty
                        //         ? const Center(
                        //             child: Text("No data :("),
                        //           )
                        //         : SpecificCard(data.specificData),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10),
                        //   child: DashboardCard(
                        //     title: "Auto Data",
                        //     body: CoachAutoData(data.autoData),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10),
                        //   child: DashboardCard(
                        //     title: "Quick data",
                        //     body: CoachQuickData(data.quickData),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10),
                        //   child: data.pitViewData.mapNullable(
                        //         PitScoutingCard.new,
                        //       ) ??
                        //       const DashboardCard(
                        //         title: "Pit scouting",
                        //         body: Center(
                        //           child: Text("No data"),
                        //         ),
                        //       ),
                        // ),
                      ],
                    ),
                  ) ??
                  (throw Exception("No data"));
            }
          },
        ),
      );
}

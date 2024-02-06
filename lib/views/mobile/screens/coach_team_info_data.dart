import "package:flutter/material.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

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
          future: fetchSingleTeamData(team.id), //fetchTeam(team.id, context),
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

class CoachTeamInfoLineCharts extends StatelessWidget {
  CoachTeamInfoLineCharts(this.data);
  final Team data;
  @override
  Widget build(final BuildContext context) => CarouselWithIndicator(
        direction: Axis.vertical,
        enableInfininteScroll: true,
        //TODO add linecharts
        widgets: const <Widget>[
          Text("Line Charts here"),
        ],
      );
}

class CoachTeamInfoLineChart extends StatelessWidget {
  const CoachTeamInfoLineChart(this.linechart, this.title);
  final Widget linechart;
  final String title;

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(title),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.only(left: 25, top: 8.0),
              child: linechart,
            ),
          ),
          const Spacer(),
        ],
      );
}

class CoachQuickData extends StatelessWidget {
  const CoachQuickData(this.data);
  final QuickData data;

  @override
  Widget build(final BuildContext context) => data.amoutOfMatches == 0
      ? const Center(child: Text("No data :("))
      : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          primary: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //TODO add quickdata ui here
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Auto",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Teleop",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Points",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Misc",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                "Matches Played: ${data.amoutOfMatches}",
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Defense Stats",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Picklist",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                "First: ${data.firstPicklistIndex + 1}",
              ),
              Text(
                textAlign: TextAlign.center,
                "Second: ${data.secondPicklistIndex + 1}",
              ),
            ],
          ),
        );
}

class CoachAutoData extends StatelessWidget {
  const CoachAutoData(this.data);
  final AutoData data;

  @override
  Widget build(final BuildContext context) => CarouselWithIndicator(
        direction: Axis.vertical,
        enableInfininteScroll: true,
        initialPage: 0,
        widgets: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "slot 1", //TODO rename
                  style: TextStyle(fontSize: 18),
                ),
              ),
              data.slot1Data.amoutOfMatches == 0
                  ? const Center(child: Text("No data"))
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[], //TODO add season specific data
                    ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "slot 2", //TODO rename
                  style: TextStyle(fontSize: 18),
                ),
              ),
              data.slot2Data.amoutOfMatches == 0
                  ? const Center(child: Text("No data"))
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[], //TODO add season specific data
                    ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "slot 3", //TODO rename
                  style: TextStyle(fontSize: 18),
                ),
              ),
              data.slot3Data.amoutOfMatches == 0
                  ? const Center(child: Text("No data"))
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[], //TODO add season specific data
                    ),
            ],
          ),
        ],
      );
}

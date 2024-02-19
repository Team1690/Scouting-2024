import "dart:collection";

import "package:carousel_slider/carousel_slider.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_all_teams.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_teams.dart";
import "package:scouting_frontend/models/matches_provider.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/coach_team_info/coach_team_info.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/pc/compare/compare_screen.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_data.dart";

class CoachView extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final List<ScheduleMatch> matchesWith1690 =
        MatchesProvider.of(context).matches;
    final List<LightTeam> teamsThatPlayWith1690 = matchesWith1690
        .map(
          (final ScheduleMatch e) =>
              <LightTeam>[...e.blueAlliance, ...e.redAlliance],
        )
        .flattened
        .toList();
    return Scaffold(
      drawer: SideNavBar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Coach"),
      ),
      body: FutureBuilder<SplayTreeSet<TeamData>>(
        future: fetchMultipleTeamData(
          teamsThatPlayWith1690.map((final LightTeam e) => e.id).toList(),
          context,
        ),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<SplayTreeSet<TeamData>> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data.mapNullable(
                  (final SplayTreeSet<TeamData> data) => CarouselSlider(
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          height: double.infinity,
                          aspectRatio: 2.0,
                          viewportFraction: 1,
                        ),
                        items: data
                            .map((final CoachData e) => matchScreen(context, e))
                            .toList(),
                      )) ??
              (throw Exception("No data"));
        },
      ),
    );
  }
}

Widget matchScreen(final BuildContext context, final CoachData data) => Column(
      children: <Widget>[
        IconButton(
          onPressed: () {
            data.mapNullable(
              (final CoachData p0) => Navigator.pushReplacement(
                context,
                MaterialPageRoute<CompareScreen>(
                  builder: (final BuildContext context) => CompareScreen(
                    <LightTeam>[
                      ...p0.blueAlliance,
                      ...p0.redAlliance,
                    ],
                  ),
                ),
              ),
            );
          },
          icon: const Icon(Icons.compare_arrows),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${data.matchType}: ${data.matchNumber}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                    " ${data.avgBlue.toInt()}",
                  ),
                  if (data.blueAlliance.length == 4)
                    Text(
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                      "${data.blueAlliance.last.team.number}: ${data.avgBlueWithFourth.toInt()}",
                    )
                  else if (data.redAlliance.length == 4)
                    const Text(""),
                ],
              ),
              Column(
                children: <Widget>[
                  const Text(style: TextStyle(fontSize: 12), " vs "),
                  if (data.redAlliance.length + data.blueAlliance.length > 6)
                    const Text(style: TextStyle(fontSize: 12), " vs "),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                    "${data.avgRed.toInt()}",
                  ),
                  if (data.redAlliance.length == 4)
                    Text(
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      "${data.redAlliance.last.team.number}: ${data.avgRedWithFourth.toInt()}",
                    )
                  else if (data.blueAlliance.length == 4)
                    const Text(""),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0.625),
                  child: Column(
                    children: data.blueAlliance
                        .map(
                          (final CoachViewLightTeam e) =>
                              Expanded(child: teamData(e, context, true)),
                        )
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0.625),
                  child: Column(
                    children: data.redAlliance
                        .map(
                          (final CoachViewLightTeam e) =>
                              Expanded(child: teamData(e, context, false)),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

const List<String> teamValues = <String>[
  "blue_0",
  "blue_1",
  "blue_2",
  "blue_3",
  "red_0",
  "red_1",
  "red_2",
  "red_3",
];

class CoachTeamData extends StatelessWidget {
  const CoachTeamData({
    super.key,
    required this.team,
    required this.context,
    required this.isBlue,
  });

  final TeamData team;
  final BuildContext context;
  final bool isBlue;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.all(defaultPadding / 4),
        child: ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.infinite),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              isBlue ? Colors.blue : Colors.red,
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<CoachTeamInfo>(
              builder: (final BuildContext context) =>
                  CoachTeamInfo(team.lightTeam),
            ),
          ),
          child: Column(
            children: <Widget>[
              const Spacer(),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    team.lightTeam.number.toString(),
                    style: TextStyle(
                      color: team.faultEntrys.isEmpty
                          ? Colors.white
                          : Colors.amber,
                      fontSize: 20,
                      fontWeight: team.lightTeam.number == 1690
                          ? FontWeight.w900
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: <Widget>[
                      if (team.aggregateData.gamesPlayed == 0)
                        const Spacer()
                      else ...<Widget>[
                        Text(
                          "Avg gamepieces: ${team.aggregateData.avgData.gamepieces}",
                        ),
                        Text(
                          "Avg Trap Amount: ${team.aggregateData.avgData.trapAmount}",
                        ),
                        Text("Aim: ${team.aim}"),
                        Text("Climb Percentage: ${team.climbPercentage}"),
                        Text(
                          "Matches Played: ${team.aggregateData.gamesPlayed}",
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

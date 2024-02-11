import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/coach_team_info/coach_team_info_data.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/pc/compare/compare_screen.dart";

class CoachView extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    int page = -1;
    List<CoachData>? coachData;
    return Scaffold(
      drawer: SideNavBar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Coach"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (page == -1) return;
              final CoachData? innerCoachData = coachData?[page];
              innerCoachData.mapNullable(
                (final CoachData p0) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<CompareScreen>(
                    builder: (final BuildContext context) =>
                        CompareScreen(<LightTeam>[
                      ...p0.blueAlliance
                          .map((final CoachViewLightTeam e) => e.team),
                      ...p0.redAlliance
                          .map((final CoachViewLightTeam e) => e.team),
                    ]),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.compare_arrows),
          ),
        ],
      ),
      body: FutureBuilder<List<CoachData>>(
        future: fetchMatches(context),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<List<CoachData>> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data.mapNullable((final List<CoachData> data) {
                final int initialIndex = data.indexWhere(
                  (final CoachData element) => !element.happened,
                );
                coachData = data;
                page = initialIndex;
                return CarouselSlider(
                  options: CarouselOptions(
                    onPageChanged:
                        (final int index, final CarouselPageChangedReason _) {
                      page = index;
                    },
                    enableInfiniteScroll: false,
                    height: double.infinity,
                    aspectRatio: 2.0,
                    viewportFraction: 1,
                    initialPage:
                        initialIndex == -1 ? data.length - 1 : initialIndex,
                  ),
                  items: data
                      .map((final CoachData e) => matchScreen(context, e))
                      .toList(),
                );
              }) ??
              (throw Exception("No data"));
        },
      ),
    );
  }
}

Widget matchScreen(final BuildContext context, final CoachData data) => Column(
      children: <Widget>[
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

//TODO add season specific tables and vars
final String query = """
query FetchCoach {
  matches(order_by: {match_type: {order: asc}, match_number: asc}) {
    happened
    match_number
    match_type {
      title
    }
    ${teamValues.map(
          (final String e) => """$e{
      colors_index
      id
      name
      number
      faults {
      message
    }
    
    }
    """,
        ).join(" ")}
  }
}



""";
Future<List<CoachData>> fetchMatches(final BuildContext context) async {
  final GraphQLClient client = getClient();
  final QueryResult<List<CoachData>> result = await client.query(
    QueryOptions<List<CoachData>>(
      document: gql(query),
      parserFn: (final Map<String, dynamic> data) {
        final List<dynamic> matches = (data["matches"] as List<dynamic>);
        return matches
            .where(
          (final dynamic element) => teamValues
              .any((final String team) => element[team]?["number"] == 1690),
        )
            .map((final dynamic match) {
          final int number = match["match_number"] as int;
          final String matchType = match["match_type"]["title"] as String;
          final bool happened = match["happened"] as bool;
          final List<CoachViewLightTeam> teams = teamValues
              .map<CoachViewLightTeam?>((final String e) {
                // Couldn't use mapNullable properly because this variable is dynamic
                if (match[e] == null) {
                  return null;
                }
                final LightTeam team = LightTeam.fromJson(match[e]);
                //TODO initialize and calculate the data you wish to display

                final List<String> faultMessages = (match[e]["faults"]
                        as List<dynamic>)
                    .map((final dynamic fault) => fault["message"] as String)
                    .toList();

                return CoachViewLightTeam(
                  team: team,
                  isBlue: e.startsWith("blue"),
                  faults: faultMessages,
                );
              })
              .whereType<CoachViewLightTeam>()
              .toList();

          final List<CoachViewLightTeam> redAlliance = teams
              .where((final CoachViewLightTeam element) => !element.isBlue)
              .toList();
          final List<CoachViewLightTeam> blueAlliance = teams
              .where((final CoachViewLightTeam element) => element.isBlue)
              .toList();
          //TODO return the actual calculated data (replace these placeholders)
          return CoachData(
            happened: happened,
            blueAlliance: blueAlliance,
            redAlliance: redAlliance,
            matchNumber: number,
            matchType: matchType,
            avgBlue: 0,
            avgRed: 0,
            avgBlueWithFourth: 0,
            avgRedWithFourth: 0,
          );
        }).toList();
      },
    ),
  );
  return result.mapQueryResult();
}

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

//TODO add season specific variables to this class
class CoachViewLightTeam {
  const CoachViewLightTeam({
    required this.team,
    required this.isBlue,
    required this.faults,
  });
  final LightTeam team;
  final bool isBlue;
  final List<String>? faults;
}

class CoachData {
  const CoachData({
    required this.happened,
    required this.blueAlliance,
    required this.redAlliance,
    required this.matchNumber,
    required this.matchType,
    required this.avgBlue,
    required this.avgRed,
    required this.avgBlueWithFourth,
    required this.avgRedWithFourth,
  });
  final int matchNumber;
  final bool happened;
  final List<CoachViewLightTeam> blueAlliance;
  final List<CoachViewLightTeam> redAlliance;
  final String matchType;
  final double avgBlueWithFourth;
  final double avgRedWithFourth;
  final double avgBlue;
  final double avgRed;
}

Widget teamData(
  final CoachViewLightTeam team,
  final BuildContext context,
  final bool isBlue,
) =>
    Padding(
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
          MaterialPageRoute<CoachTeamData>(
            builder: (final BuildContext context) => CoachTeamData(team.team),
          ),
        ),
        child: Column(
          children: <Widget>[
            const Spacer(),
            Expanded(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  team.team.number.toString(),
                  style: TextStyle(
                    color: team.faults == null || team.faults!.isEmpty
                        ? Colors.white
                        : Colors.amber,
                    fontSize: 20,
                    fontWeight: team.team.number == 1690
                        ? FontWeight.w900
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  children: <Widget>[
                    //TODO add this condition as a validator (we dont care about data from teams with no matches, obviously):
                    // if (team.amountOfMatches == 0)
                    //   ...List<Spacer>.filled(7, const Spacer())
                    // else
                    ...<Widget>[
                      //TODO display your data
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

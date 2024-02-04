import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/common/fetch_functions/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/all_teams/all_team_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/all_teams/fetch_all_teams.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/pc/auto_picklist/auto_picklist_widget.dart";
import "package:scouting_frontend/views/pc/auto_picklist/value_sliders.dart";

class AutoPickListScreen extends StatefulWidget {
  const AutoPickListScreen({super.key});

  @override
  State<AutoPickListScreen> createState() => _AutoPickListScreenState();
}

class _AutoPickListScreenState extends State<AutoPickListScreen> {
  bool hasValues = false;

//TODO rename to your selected factors and filters
  double factor2 = 0.5;
  double factor1 = 0.5;
  double factor3 = 0.5;
  bool filter = false;
  Picklists? saveAs;

  List<AutoPickListTeam> localList = <AutoPickListTeam>[];

  @override
  Widget build(final BuildContext context) => isPC(context)
      ? DashboardScaffold(
          body: pickList(context),
        )
      : Scaffold(
          appBar: AppBar(
            title: const Text("Picklist"),
            centerTitle: true,
          ),
          drawer: SideNavBar(),
          body: pickList(context),
        );

  Container pickList(final BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ValueSliders(
                onButtonPress: (
                  final double slider0,
                  final double slider1,
                  final double slider2,
                  final bool feeder,
                ) =>
                    setState(() {
                  hasValues = true;
                  factor1 = slider0;
                  factor2 = slider1;
                  factor3 = slider2;
                  filter = feeder;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              SectionDivider(label: "Actions"),
              const SizedBox(
                height: 10,
              ),
              Selector<String>(
                options: Picklists.values
                    .map((final Picklists e) => e.title)
                    .toList(),
                placeholder: "Save as:",
                value: saveAs?.title,
                makeItem: (final String picklist) => picklist,
                onChange: (final String newTitle) => setState(() {
                  saveAs = Picklists.values.firstWhere(
                    (final Picklists picklists) => picklists.title == newTitle,
                  );
                }),
                validate: (final String unused) => null,
              ),
              const SizedBox(
                height: 10,
              ),
              RoundedIconButton(
                color: Colors.blue,
                onPress: () => save(
                  saveAs,
                  List<AllTeamData>.from(
                    localList.map(
                      (final AutoPickListTeam autoTeam) =>
                          autoTeam.picklistTeam,
                    ),
                  ),
                  context,
                ),
                icon: Icons.save_as,
                onLongPress: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              hasValues
                  ? Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: StreamBuilder<List<AllTeamData>>(
                        stream: fetchAllTeams(),
                        builder: (
                          final BuildContext context,
                          final AsyncSnapshot<List<AllTeamData>> snapshot,
                        ) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data == null) {
                            return const Center(
                              child: Text("No Teams"),
                            );
                          }
                          final List<AutoPickListTeam> teamsList =
                              snapshot.data!
                                  .map(
                                    (final AllTeamData e) => AutoPickListTeam(
                                      //TODO initialize actual data using the fetched data from the query
                                      factor1: 1,
                                      factor2: 1,
                                      facotr3: 1,
                                      picklistTeam: e,
                                    ),
                                  )
                                  .toList();
                          teamsList.sort(
                            (
                              final AutoPickListTeam a,
                              final AutoPickListTeam b,
                            ) =>
                                (b.facotr3 * factor3 +
                                        b.factor1 * factor1 +
                                        b.factor2 * factor2)
                                    .compareTo(
                              a.facotr3 * factor3 +
                                  a.factor1 * factor1 +
                                  a.factor2 * factor2,
                            ),
                          );
                          //TODO in order to filter out according to the filter selected, there should be a similar if statement to the one commented below

                          // if (filterFeeder) {
                          // localList = teamsList
                          //     .where(
                          //       (final AutoPickListTeam element) =>
                          //           element
                          //               .picklistTeam.filter1 !=
                          //           true,
                          //     )
                          //     .toList();
                          // teamsList.removeWhere(
                          //   (final AutoPickListTeam element) =>
                          //       element.picklistTeam.filter !=
                          //       true,
                          // );
                          // localList.insertAll(0, teamsList);
                          // teamsList.clear();
                          // teamsList.addAll(localList);
                          // } else
                          {
                            localList = teamsList;
                          }
                          return AutoPickList(uiList: localList);
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
}

enum Picklists {
  first("First"),
  second("Second"),
  third("Third");

  const Picklists(this.title);
  final String title;
}

void save(
  final Picklists? picklist,
  final List<AllTeamData> teams, [
  final BuildContext? context,
]) async {
  if (teams.isNotEmpty && picklist != null) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Saving", style: TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: Colors.blue,
        ),
      );
    }
    final GraphQLClient client = getClient();
    const String query = """
  mutation UpdatePicklist(\$objects: [team_insert_input!]!) {
  insert_team(objects: \$objects, on_conflict: {constraint: team_pkey, update_columns: [taken, first_picklist_index, second_picklist_index,third_picklist_index]}) {
    affected_rows
    returning {
      id
    }
  }
}

  """;
//TODO add season specific vars
    final Map<String, dynamic> vars = <String, dynamic>{
      "objects": teams
          .map(
            (final AllTeamData e) => AllTeamData(
              firstPicklistIndex: picklist == Picklists.first
                  ? teams.indexOf(e)
                  : e.firstPicklistIndex,
              secondPicklistIndex: picklist == Picklists.second
                  ? teams.indexOf(e)
                  : e.secondPicklistIndex,
              thirdPickListIndex: picklist == Picklists.third
                  ? teams.indexOf(e)
                  : e.thirdPickListIndex,
              taken: e.taken,
              team: e.team,
              faultMessages: <String>[],
              autoGamepieceAvg: 0,
              teleGamepieceAvg: 0,
              gamepieceAvg: 0,
              gamepiecePointAvg: 0,
              brokenMatches: 0,
              amountOfMatches: 0,
              matchesClimbed: 0,
              workedPercentage: 0,
              climbedPercentage: 0,
              aggregateData: AggregateData.parse(0),
            ),
          )
          .map(
            (final AllTeamData e) => <String, dynamic>{
              "id": e.team.id,
              "name": e.team.name,
              "number": e.team.number,
              "colors_index": e.team.colorsIndex,
              "first_picklist_index": e.firstPicklistIndex,
              "second_picklist_index": e.secondPicklistIndex,
              "third_picklist_index": e.thirdPickListIndex,
              "taken": e.taken,
            },
          )
          .toList(),
    };

    final QueryResult<void> result = await client
        .mutate(MutationOptions<void>(document: gql(query), variables: vars));
    if (context != null) {
      if (result.hasException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text("Error: ${result.exception}"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Saved",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}

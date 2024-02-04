import "dart:math";

import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
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
  double speakerFactor = 0.5;
  double ampFactor = 0.5;
  double climbFactor = 0.5;
  double trapFactor = 0.5;
  bool filter = false;
  Picklists? saveAs;

  List<AllTeamData> localList = <AllTeamData>[];

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
                  final double climbSlider,
                  final double ampSlider,
                  final double speakerSlider,
                  final double trapSlider,
                  final bool feeder,
                ) =>
                    setState(() {
                  hasValues = true;
                  climbFactor = 1 - climbSlider;
                  ampFactor = 1 - ampSlider;
                  speakerFactor = 1 - speakerSlider;
                  trapFactor = 1 - trapSlider;
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
                  localList
                      .map(
                        (final AllTeamData autoTeam) => autoTeam,
                      )
                      .toList(),
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
                        ) =>
                            snapshot.mapSnapshot(
                          onSuccess: (final List<AllTeamData> teams) {
                            final List<AllTeamData> teamsList = snapshot.data!;
                            final double maxAmp = teamsList
                                    .map(
                                      (final AllTeamData e) =>
                                          e.aggregateData.avgAutoAmp,
                                    )
                                    .fold(0.0, max) +
                                teamsList
                                    .map(
                                      (final AllTeamData e) =>
                                          e.aggregateData.avgTeleAmp,
                                    )
                                    .fold(0.0, max);
                            final double maxSpeaker = teamsList
                                    .map(
                                      (final AllTeamData e) =>
                                          e.aggregateData.avgAutoSpeaker,
                                    )
                                    .fold(0.0, max) +
                                teamsList
                                    .map(
                                      (final AllTeamData e) =>
                                          e.aggregateData.avgTeleSpeaker,
                                    )
                                    .fold(0.0, max);
                            teamsList.sort(
                              (
                                final AllTeamData b,
                                final AllTeamData a,
                              ) =>
                                  (a.climbedPercentage * climbFactor / 100 +
                                          (a.aggregateData.avgAutoAmp +
                                                  a.aggregateData.avgTeleAmp) *
                                              ampFactor /
                                              maxAmp +
                                          (a.aggregateData.avgAutoSpeaker +
                                                  a.aggregateData
                                                      .avgTeleSpeaker) *
                                              speakerFactor /
                                              maxSpeaker +
                                          a.aggregateData.avgTrapAmount *
                                              trapFactor /
                                              2)
                                      .compareTo(
                                b.climbedPercentage * climbFactor / 100 +
                                    (b.aggregateData.avgAutoAmp +
                                            b.aggregateData.avgTeleAmp) *
                                        ampFactor /
                                        maxAmp +
                                    (b.aggregateData.avgAutoSpeaker +
                                            b.aggregateData.avgTeleSpeaker) *
                                        speakerFactor /
                                        maxSpeaker +
                                    b.aggregateData.avgTrapAmount *
                                        trapFactor /
                                        2,
                              ),
                            );
                            teamsList.forEach((final a) {
                              print(
                                "${a.team.number} ${a.climbedPercentage * climbFactor / 100 + (a.aggregateData.avgAutoAmp + a.aggregateData.avgTeleAmp) * ampFactor / maxAmp + (a.aggregateData.avgAutoSpeaker + a.aggregateData.avgTeleSpeaker) * speakerFactor / maxSpeaker + a.aggregateData.avgTrapAmount * trapFactor / 2} climb: ${a.climbedPercentage}",
                              );
                            });
                            localList = teamsList;
                            return AutoPickList(uiList: localList);
                          },
                          onWaiting: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          onNoData: () => const Center(
                            child: Text("No Teams"),
                          ),
                          onError: (final Object error) =>
                              Text(snapshot.error.toString()),
                        ),
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
              autoGamepieceAvg: e.autoGamepieceAvg,
              teleGamepieceAvg: e.teleGamepieceAvg,
              gamepieceAvg: e.gamepieceAvg,
              gamepiecePointAvg: e.gamepiecePointAvg,
              brokenMatches: e.brokenMatches,
              amountOfMatches: e.amountOfMatches,
              matchesClimbed: e.matchesClimbed,
              workedPercentage: e.workedPercentage,
              climbedPercentage: e.climbedPercentage,
              aggregateData: e.aggregateData,
              aim: e.aim,
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

import "package:flutter/material.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
import "package:scouting_frontend/models/team_data/team_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";

class MichalScreen extends StatefulWidget {
  const MichalScreen({super.key});

  @override
  State<MichalScreen> createState() => _MichalScreenState();
}

class _MichalScreenState extends State<MichalScreen> {
  late TextEditingController controller1 = TextEditingController();
  late TextEditingController controller2 = TextEditingController();
  late TextEditingController controller3 = TextEditingController();
  LightTeam? team1;
  LightTeam? team2;
  LightTeam? team3;
  bool showAllianceCards = false;
  @override
  Widget build(final BuildContext context) => Scaffold(
        drawer: SideNavBar(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Michal"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  showAllianceCards =
                      team1 != null && team2 != null && team3 != null;
                });
              },
              icon: const Icon(Icons.soup_kitchen_rounded),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TeamSelectionFuture(
                    onChange: (final LightTeam newTeam) {
                      team1 = newTeam;
                    },
                    controller: controller1,
                  ),
                ),
                Expanded(
                  child: TeamSelectionFuture(
                    onChange: (final LightTeam newTeam) {
                      team2 = newTeam;
                    },
                    controller: controller2,
                  ),
                ),
                Expanded(
                  child: TeamSelectionFuture(
                    onChange: (final LightTeam newTeam) {
                      team3 = newTeam;
                    },
                    controller: controller3,
                  ),
                ),
              ],
            ),
            if (showAllianceCards)
              Row(
                children: <Widget>[
                  AllianceCard(
                    teamNumber: team1!.number,
                  ),
                  AllianceCard(
                    teamNumber: team2!.number,
                  ),
                  AllianceCard(
                    teamNumber: team3!.number,
                  ),
                ],
              ),
          ],
        ),
      );
}

class AllianceCard extends StatelessWidget {
  const AllianceCard({super.key, required this.teamNumber});
  final int teamNumber;

  @override
  Widget build(final BuildContext context) => FutureBuilder<TeamData>(
        future: fetchSingleTeamData(teamNumber, context),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<TeamData> snapshot,
        ) =>
            DashboardCard(
          title: "$teamNumber",
          body: Column(
            children: <Widget>[
              SectionDivider(label: "Autonomous:"),
              Text(
                "Average Speaker:  ${snapshot.data?.aggregateData.avgData.autoSpeaker}",
              ),
              Text(
                "Average Amp: ${snapshot.data?.aggregateData.avgData.autoAmp}",
              ),
              SectionDivider(label: "Teleop"),
              Text(
                "Average Speaker: ${snapshot.data?.aggregateData.avgData.teleSpeaker}",
              ),
              Text(
                "Average Amp: ${snapshot.data?.aggregateData.avgData.teleAmp}",
              ),
              SectionDivider(label: "Other"),
              Text(
                "Climbing Percentage: ${snapshot.data?.climbPercentage}",
              ),
              Text(
                "Average Trap Amount: ${snapshot.data?.aggregateData.avgData.trapAmount}",
              ),
            ],
          ),
        ),
      );
}

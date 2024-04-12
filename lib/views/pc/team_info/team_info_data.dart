import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:scouting_frontend/models/data/team_data/team_data_extensions.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/auto_data/auto_data_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/gamechart/gamechart_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/pit_scouting.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/quick_data/quick_data_card.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/specific/specific_card.dart";

class TeamInfoData extends StatelessWidget {
  TeamInfoData(this.team);
  final LightTeam team;

  @override
  Widget build(final BuildContext context) => StreamBuilder<TeamData>(
        stream: fetchSingleTeamData(team.id, context),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<TeamData> snapShot,
        ) =>
            snapShot.mapSnapshot(
          onSuccess: (final TeamData data) => Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: <Widget>[
                          Expanded(child: QuickDataCard(data: data.quickData)),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Expanded(child: AutoDataCard(data: data.autoData)),
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Expanded(
                      flex: 6,
                      child: Gamechart(data: data),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                flex: 2,
                child: SpecificCard(
                  team: data.lightTeam,
                  matchData: data.matches,
                  summaryData: data.summaryData,
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                flex: 2,
                child: PitScouting(data),
              ),
            ],
          ),
          onWaiting: () => const Center(
            child: CircularProgressIndicator(),
          ),
          onNoData: () => const Text("No data available"),
          onError: (final Object error) =>
              Center(child: Text(snapShot.error.toString())),
        ),
      );
}

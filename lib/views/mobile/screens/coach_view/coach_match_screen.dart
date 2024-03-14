import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_team_card.dart";
import "package:scouting_frontend/legacy/alliance_auto_planner/auto_planner_screen.dart";
import "package:scouting_frontend/views/pc/compare/compare_screen.dart";

class CoachMatchScreen extends StatelessWidget {
  const CoachMatchScreen({
    super.key,
    required this.match,
    required this.blueAllianceTeams,
    required this.redAllianceTeams,
  });

  final ScheduleMatch match;
  final List<TeamData> blueAllianceTeams;
  final List<TeamData> redAllianceTeams;
  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          IconButton(
            onPressed: () {
              match.mapNullable(
                (final ScheduleMatch match) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<CompareScreen>(
                    builder: (final BuildContext context) => CompareScreen(
                      <LightTeam>[
                        ...match.blueAlliance,
                        ...match.redAlliance,
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
            child: Text(
              "${match.matchIdentifier.type.title}: ${match.matchIdentifier.number}",
            ),
          ),
          Text(
            "${blueAllianceTeams.map((final TeamData e) => e.aggregateData.medianData.gamePiecesPoints).average.toStringAsFixed(2)} vs ${redAllianceTeams.map((final TeamData e) => e.aggregateData.medianData.gamePiecesPoints).average.toStringAsFixed(2)}",
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0.625),
                    child: Column(
                      children: <Widget>[
                        ...match.blueAlliance.map(
                          (final LightTeam e) => Expanded(
                            child: CoachTeamCard(
                              team: blueAllianceTeams.firstWhere(
                                (final TeamData element) =>
                                    element.lightTeam == e,
                              ),
                              context: context,
                              isBlue: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0.625),
                    child: Column(
                      children: <Widget>[
                        ...match.redAlliance.map(
                          (final LightTeam e) => Expanded(
                            child: CoachTeamCard(
                              team: redAllianceTeams.firstWhere(
                                (final TeamData element) =>
                                    element.lightTeam == e,
                              ),
                              context: context,
                              isBlue: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

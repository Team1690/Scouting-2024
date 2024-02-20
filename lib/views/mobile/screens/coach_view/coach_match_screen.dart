import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_team_data.dart";
import "package:scouting_frontend/views/pc/compare/compare_screen.dart";

class CoachMatchScreen extends StatelessWidget {
  const CoachMatchScreen({super.key, required this.match, required this.teams});

  final ScheduleMatch match;
  final List<TeamData> teams;
  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          IconButton(
            onPressed: () {
              match.mapNullable(
                (final ScheduleMatch p0) => Navigator.pushReplacement(
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
            child: Text(
              "${match.matchIdentifier.type.title}: ${match.matchIdentifier.number}",
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0.625),
                    child: Column(
                      children: match.blueAlliance
                          .map(
                            (final LightTeam e) => Expanded(
                              child: CoachTeam(
                                team: teams.firstWhere(
                                  (final TeamData element) =>
                                      element.lightTeam == e,
                                ),
                                context: context,
                                isBlue: true,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0.625),
                    child: Column(
                      children: match.redAlliance
                          .map(
                            (final LightTeam e) => Expanded(
                              child: CoachTeam(
                                team: teams.firstWhere(
                                  (final TeamData element) =>
                                      element.lightTeam == e,
                                ),
                                context: context,
                                isBlue: false,
                              ),
                            ),
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
}

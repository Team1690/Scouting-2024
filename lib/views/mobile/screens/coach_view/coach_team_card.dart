import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/coach_team_info/coach_team_info.dart";

class CoachTeamCard extends StatelessWidget {
  const CoachTeamCard({
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
            minimumSize: WidgetStateProperty.all(Size.infinite),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(
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
                      fontSize: 25,
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
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      children: <Widget>[
                        if (team.aggregateData.gamesPlayed == 0)
                          const Spacer()
                        else ...<Widget>[
                          Text(
                            "Avg cycle score: ${team.aggregateData.avgData.cycleScore.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg gamepieces scored: ${team.aggregateData.avgData.gamepieces.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Avg Trap Amount: ${team.aggregateData.avgData.trapAmount.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Aim: ${team.aim.isFinite ? "${team.aim.toStringAsFixed(2)}%" : "No Data"}",
                          ),
                          Text(
                            "Climb Percentage: ${team.climbPercentage.isFinite ? "${team.climbPercentage.toStringAsFixed(2)}%" : "No Data"}",
                          ),
                          Text(
                            "Matches Played: ${team.aggregateData.gamesPlayed}",
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

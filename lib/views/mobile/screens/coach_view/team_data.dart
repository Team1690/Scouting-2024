import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_team_info_data.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_view_light_team.dart";

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

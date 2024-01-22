import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_data.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/coach_view_light_team.dart";
import "package:scouting_frontend/views/mobile/screens/coach_view/team_data.dart";

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

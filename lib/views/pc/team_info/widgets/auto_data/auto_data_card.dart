import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/autonomous_options_enum.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_info_models/auto_data.dart";
import "package:scouting_frontend/views/common/card.dart";

class AutoDataCard extends StatelessWidget {
  const AutoDataCard({super.key, required this.data});

  final AutoData data;
  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "",
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text(
                    "Auto Data",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Avg Auto Gamepieces: ${(data.avgData.autoGamepieces).toStringAsFixed(2)}",
                  ),
                  Text(
                    "Min Auto Gamepieces: ${(data.minData.autoGamepieces).toStringAsFixed(2)}",
                  ),
                  Text(
                    "Max Auto Gamepieces: ${(data.maxData.autoGamepieces).toStringAsFixed(2)}",
                  ),
                  const Divider(),
                  ...data.autos.map(
                    (final (MatchIdentifier, AutonomousOptions) e) => Text(
                      "Match - ${e.$1} : ${e.$2.title}",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

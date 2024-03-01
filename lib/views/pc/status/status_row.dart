import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/views/constants.dart";

class StatusRow extends StatelessWidget {
  const StatusRow({
    super.key,
    this.leading,
    required this.statusBoxBuilder,
    required this.data,
  });

  final Widget? leading;
  final Widget Function(TeamData) statusBoxBuilder;
  final List<TeamData> data;

  @override
  Widget build(final BuildContext context) => Card(
        color: bgColor,
        elevation: 2,
        margin: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: <Widget>[
              if (leading != null) leading!,
              ListView(
                scrollDirection: Axis.horizontal,
                children: data.map(statusBoxBuilder).toList(),
              ),
            ],
          ),
        ),
      );
}

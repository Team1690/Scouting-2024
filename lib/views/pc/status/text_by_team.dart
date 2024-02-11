import "package:flutter/material.dart";
import "package:scouting_frontend/views/pc/status/status_match.dart";

class TextByTeam extends StatelessWidget {
  const TextByTeam({required this.match, required this.text});
  final StatusMatch match;
  final String text;
  @override
  Widget build(final BuildContext context) => Text(
        style: TextStyle(color: match.scoutedTeam.allianceColor),
        text,
      );
}

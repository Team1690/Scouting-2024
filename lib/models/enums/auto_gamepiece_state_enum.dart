import "package:flutter/material.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";

enum AutoGamepieceState implements IdEnum {
  scoredSpeaker("Scored Speaker", Icons.my_location, Colors.green),
  missedSpeaker("Missed Speaker", Icons.location_disabled, Colors.yellow),
  notTaken("Not Taken", Icons.radio_button_off, Colors.red),
  noAttempt("No Attempt", Icons.close, Colors.grey);

  const AutoGamepieceState(this.title, this.icon, this.color);

  @override
  final String title;
  final IconData icon;
  final Color color;
}

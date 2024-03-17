import "package:flutter/material.dart";
import "package:scouting_frontend/models/id_providers.dart";

enum AutoGamepieceState implements IdEnum {
  scoredSpeaker("Scored Speaker", Icons.my_location),
  missedSpeaker("Missed Speaker", Icons.location_disabled),
  notTaken("Not Taken", Icons.radio_button_off),
  noAttempt("No Attempt", Icons.close);

  const AutoGamepieceState(this.title, this.icon);

  @override
  final String title;
  final IconData icon;
}

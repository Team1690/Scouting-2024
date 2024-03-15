import "package:flutter/material.dart";
import "package:scouting_frontend/models/id_providers.dart";

enum AutoGamepieceState implements IdEnum {
  scoredSpeaker("Scored Speaker", Icons.my_location),
  missedSpeaker("Missed Speaker", Icons.location_disabled),
  scoredAmp("Scored Amp", Icons.wifi_tethering_outlined),
  missedAmp("Missed Amp", Icons.wifi_tethering_off),
  notTaken("Not Taken", Icons.radio_button_off);

  const AutoGamepieceState(this.title, this.icon);

  @override
  final String title;
  final IconData icon;
}

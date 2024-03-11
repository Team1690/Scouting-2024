import "package:flutter/material.dart";
import "package:scouting_frontend/models/id_providers.dart";

enum RobotFieldStatus implements IdEnum {
  worked("Worked", Colors.green),
  didntComeToField("Didn't come to field", Colors.red),
  didntWorkOnField("Didn't work on field", Colors.purple),
  didDefense("Did Defense", Colors.blue);

  const RobotFieldStatus(this.title, this.color);

  @override
  final String title;
  final Color color;
}

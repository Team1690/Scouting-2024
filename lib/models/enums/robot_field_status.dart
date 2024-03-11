import "package:flutter/material.dart";

enum RobotFieldStatus {
  worked("Worked", Colors.green),
  didntComeToField("Didn't come to field", Colors.red),
  didntWorkOnField("Didn't work on field", Colors.purple),
  didDefense("Did Defense", Colors.blue);

  const RobotFieldStatus(this.title, this.color);

  final String title;
  final Color color;
}

RobotFieldStatus robotFieldStatusTitleToEnum(final String title) =>
    RobotFieldStatus.values
        .where((final RobotFieldStatus element) => element.title == title)
        .singleOrNull ??
    (throw Exception("Not A Valid Robot Field Status Title"));

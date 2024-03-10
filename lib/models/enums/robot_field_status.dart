import "package:flutter/material.dart";

enum RobotFieldStatus {
  worked("Worked", Colors.black),
  didntComeToField("Didn't come to field", Colors.purple),
  didntWorkOnField("Didn't work on field", Colors.red),
  didDefence("Did Defence", Colors.blue);

  const RobotFieldStatus(this.title, this.color);

  final String title;
  final Color color;
}

RobotFieldStatus robotFieldStatusTitleToEnum(final String title) =>
    RobotFieldStatus.values
        .where(
          (final RobotFieldStatus robotFieldStatusOption) =>
              robotFieldStatusOption.title == title,
        )
        .singleOrNull ??
    (throw Exception("Invalid title: $title"));

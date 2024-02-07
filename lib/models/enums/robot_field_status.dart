enum RobotFieldStatus {
  worked("Worked"),
  didntComeToField("Didn't come to field"),
  didntWorkOnField("Didn't work on field");

  const RobotFieldStatus(this.title);

  final String title;
}

RobotFieldStatus robotFieldStatusTitleToEnum(final String title) {
  switch (title) {
    case "Worked":
      return RobotFieldStatus.worked;
    case "Didn't come to field":
      return RobotFieldStatus.didntComeToField;
    case "Didn't work on field":
      return RobotFieldStatus.didntWorkOnField;
  }
  throw Exception("Isn't a valid title");
}

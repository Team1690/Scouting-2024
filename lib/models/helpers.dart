import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

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

Defense defenseAmountTitleToEnum(final String title) {
  switch (title) {
    case "No Defense":
      return Defense.noDefense;
    case "Half Defense":
      return Defense.halfDefense;
    case "Full Defense":
      return Defense.fullDefense;
  }
  throw Exception("Isn't a valid title");
}

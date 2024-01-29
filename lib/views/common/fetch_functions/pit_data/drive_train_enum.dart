enum DriveTrain {
  swerve("Swerve"),
  westCoast("West Coast"),
  kitChassis("Kit Chassis"),
  customTank("Custom Tank"),
  mecanumOrH("Mecanum/H"),
  other("Other");

  const DriveTrain(final String title);
}

DriveTrain driveTrainTitleToEnum(final String title) {
  switch (title) {
    case "Swerve":
      return DriveTrain.swerve;
    case "West Coast":
      return DriveTrain.westCoast;
    case "Kit Chassis":
      return DriveTrain.kitChassis;
    case "Custom Tank":
      return DriveTrain.customTank;
    case "Mecanum/H":
      return DriveTrain.mecanumOrH;
    case "Other":
      return DriveTrain.other;
  }
  throw Exception("Isn't a valid title");
}

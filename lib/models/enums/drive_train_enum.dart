import "package:scouting_frontend/models/id_providers.dart";

enum DriveTrain implements IdEnum {
  swerve("Swerve"),
  westCoast("West Coast"),
  kitChassis("Kit Chassis"),
  customTank("Custom Tank"),
  mecanumOrH("Mecanum/H"),
  other("Other");

  const DriveTrain(this.title);
  @override
  final String title;
}

enum DriveMotor {
  falcon("Falcon"),
  neo("NEO"),
  neoVortex("Neo Vortex"),
  cim("CIM"),
  miniCIM("Mini CIM"),
  kraken("Kraken"),
  other("Other");

  const DriveMotor(this.title);
  final String title;
}

DriveMotor driveMotorTitleToEnum(final String title) {
  switch (title) {
    case "Falcon":
      return DriveMotor.falcon;
    case "NEO":
      return DriveMotor.neo;
    case "Neo Vortex":
      return DriveMotor.neoVortex;
    case "CIM":
      return DriveMotor.cim;
    case "Mini CIM":
      return DriveMotor.miniCIM;
    case "Kraken":
      return DriveMotor.kraken;
    case "Other":
      return DriveMotor.other;
  }
  throw Exception("Isn't a valid title");
}

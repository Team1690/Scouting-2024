enum DriveWheel {
  tread("Tread"),
  colson("Colson"),
  hiGrip("Hi-grip"),
  mecanum("Mecanum"),
  omni("Omni"),
  other("Other");

  const DriveWheel(this.title);
  final String title;
}

DriveWheel driveWheelTitleToEnum(final String title) {
  switch (title) {
    case "Tread":
      return DriveWheel.tread;
    case "Colson":
      return DriveWheel.colson;
    case "Hi-grip":
      return DriveWheel.hiGrip;
    case "Mecanum":
      return DriveWheel.mecanum;
    case "Omni":
      return DriveWheel.omni;
    case "Other":
      return DriveWheel.other;
  }
  throw Exception("Isn't a valid title");
}

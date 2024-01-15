import "package:scouting_frontend/views/mobile/hasura_vars.dart";

class PitVars implements HasuraVars {
  //TODO add season specific vars
  int? driveTrainType;
  int? driveMotorType;
  int driveMotorAmount = 2;
  bool? hasShifter;
  bool? gearboxPurchased;
  String notes = "";
  String? driveWheelType;
  int? teamId;
  String weight = "";
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        //TODO add season specific vars
        "drivetrain_id": driveTrainType,
        "drivemotor_id": driveMotorType,
        "drive_motor_amount": driveMotorAmount,
        "has_shifter": hasShifter,
        "gearbox_purchased": gearboxPurchased,
        "notes": notes,
        "drive_wheel_type": driveWheelType ?? "",
        "team_id": teamId,
        "weight": int.parse(weight),
      };

  void reset() {
    //TODO add season specific vars
    driveTrainType = null;
    driveMotorType = null;
    driveMotorAmount = 2;
    hasShifter = null;
    gearboxPurchased = null;
    notes = "";
    driveWheelType = null;
    teamId = null;
    weight = "";
  }
}

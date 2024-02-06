import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/enums/drive_wheel_enum.dart";

class PitData {
  PitData({
    required this.driveTrainType,
    required this.driveMotorAmount,
    required this.driveWheelType,
    required this.hasShifer,
    required this.gearboxPurchased,
    required this.driveMotorType,
    required this.notes,
    required this.weight,
    required this.height,
    required this.harmony,
    required this.hasBuddyClimb,
    required this.trap,
    required this.url,
    required this.faultMessages,
    required this.team,
    required this.otherWheelType,
  });

  final DriveTrain driveTrainType;
  final int driveMotorAmount;
  final DriveWheel driveWheelType;
  final bool? hasShifer;
  final bool? gearboxPurchased;
  final DriveMotor driveMotorType;
  final String notes;
  final double weight;
  final double height;
  final bool harmony;
  final bool hasBuddyClimb;
  final int trap;
  final String url;
  final List<String>? faultMessages;
  final LightTeam team;
  final String? otherWheelType;

  static PitData? parse(final dynamic pit) =>
      pit != null && pit["drivetrain"] != null
          ? PitData(
              driveTrainType:
                  driveTrainTitleToEnum(pit["drivetrain"]["title"] as String),
              driveMotorAmount: pit["drive_motor_amount"] as int,
              driveMotorType:
                  driveMotorTitleToEnum(pit["drivemotor"]["title"] as String),
              driveWheelType:
                  driveWheelTitleToEnum(pit["wheel_type"]["title"] as String),
              gearboxPurchased: pit["gearbox_purchased"] as bool?,
              notes: pit["notes"] as String,
              hasShifer: pit["has_shifter"] as bool?,
              url: pit["url"] as String,
              faultMessages: (pit["team"]["faults"] as List<dynamic>)
                  .map((final dynamic fault) => fault["message"] as String)
                  .toList(),
              weight: (pit["weight"] as num).toDouble(),
              team: LightTeam.fromJson(pit["team"]),
              height: (pit["height"] as num).toDouble(),
              harmony: pit["harmony"] as bool,
              trap: pit["trap"] as int,
              hasBuddyClimb: pit["has_buddy_climb"] as bool,
              otherWheelType: pit["other_wheel_type"] as String?,
            )
          : null;
}

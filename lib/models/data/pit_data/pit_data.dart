import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/team_model.dart";

class PitData {
  const PitData({
    required this.length,
    required this.width,
    required this.driveTrainType,
    required this.driveMotorType,
    required this.notes,
    required this.weight,
    required this.harmony,
    required this.trap,
    required this.url,
    required this.faultMessages,
    required this.team,
    required this.canEject,
    required this.canPassUnderStage,
  });

  final DriveTrain driveTrainType;
  final DriveMotor driveMotorType;
  final String notes;
  final double weight;
  final double length;
  final double width;
  final bool harmony;
  final int trap;
  final bool canEject;
  final bool canPassUnderStage;
  final String url;
  final List<String>? faultMessages;
  final LightTeam team;

  static PitData? parse(final dynamic pit) => pit != null
      ? PitData(
          driveTrainType:
              driveTrainTitleToEnum(pit["drivetrain"]["title"] as String),
          driveMotorType:
              driveMotorTitleToEnum(pit["drivemotor"]["title"] as String),
          notes: pit["notes"] as String,
          url: pit["url"] as String,
          faultMessages: (pit["team"]["faults"] as List<dynamic>)
              .map((final dynamic fault) => fault["message"] as String)
              .toList(),
          weight: (pit["weight"] as num).toDouble(),
          length: (pit["length"] as num).toDouble(),
          width: (pit["width"] as num).toDouble(),
          team: LightTeam.fromJson(pit["team"]),
          harmony: pit["harmony"] as bool,
          trap: pit["trap"] as int,
          canEject: pit["can_eject"] as bool,
          canPassUnderStage: pit["can_pass_under_stage"] as bool,
        )
      : null;
}

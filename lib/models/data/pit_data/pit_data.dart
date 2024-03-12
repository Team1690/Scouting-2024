import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/id_providers.dart";
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
    required this.allRangeShooting,
    required this.climb,
  });

  final DriveTrain driveTrainType;
  final DriveMotor driveMotorType;
  final String notes;
  final double weight;
  final double length;
  final double width;
  final bool harmony;
  final bool trap;
  final bool canEject;
  final bool canPassUnderStage;
  final String url;
  final List<String>? faultMessages;
  final LightTeam team;
  final bool allRangeShooting;
  final bool climb;

  static PitData? parse(final dynamic pit, final IdProvider idProvider) =>
      pit != null
          ? PitData(
              driveTrainType: idProvider
                  .driveTrain.idToEnum[pit["drivetrain"]["id"] as int]!,
              driveMotorType: idProvider
                  .drivemotor.idToEnum[pit["drivemotor"]["id"] as int]!,
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
              trap: pit["trap"] as bool,
              canEject: pit["can_eject"] as bool,
              canPassUnderStage: pit["can_pass_under_stage"] as bool,
              allRangeShooting: pit["all_range_shooting"] as bool,
              climb: pit["climb"] as bool,
            )
          : null;
}

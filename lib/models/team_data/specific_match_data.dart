import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class SpecificMatchData {
  const SpecificMatchData({
    required this.isRematch,
    required this.matchNumber,
    required this.matchTypeId,
    required this.scouterNames,
    required this.drivetrainAndDriving,
    required this.intake,
    required this.amp,
    required this.speaker,
    required this.climb,
    required this.defense,
    required this.general,
    required this.defenseAmount,
    required this.url,
    required this.scheduleMatchId,
  });
  final int matchNumber;
  final int matchTypeId;
  final int scheduleMatchId;
  final String scouterNames;
  final bool isRematch;

  final int? drivetrainAndDriving;
  final int? intake;
  final int? speaker;
  final int? amp;
  final int? climb;
  final int? defense;
  final int? general;
  final String url;
  final DefenseAmount defenseAmount;

  bool isNull(final String val) {
    switch (val) {
      case "Drivetrain And Driving":
        return drivetrainAndDriving == null;
      case "Intake":
        return intake == null;
      case "Speaker":
        return speaker == null;
      case "Amp":
        return amp == null;
      case "Climb":
        return climb == null;
      case "Defense":
        return defense == null;
      case "General Notes":
        return general == null;
      case "All":
      default:
        return (drivetrainAndDriving == null &&
                intake == null &&
                speaker == null &&
                amp == null &&
                climb == null &&
                defense == null &&
                general == null)
            ? true
            : false;
    }
  }

  static SpecificMatchData parse(final dynamic specificMatchTable) =>
      SpecificMatchData(
        scheduleMatchId: specificMatchTable["schedule_match"]["id"] as int,
        isRematch: specificMatchTable["is_rematch"] as bool,
        matchNumber:
            specificMatchTable["schedule_match"]["match_number"] as int,
        matchTypeId:
            specificMatchTable["schedule_match"]["match_type_id"] as int,
        scouterNames: specificMatchTable["scouter_name"] as String,
        drivetrainAndDriving: specificMatchTable["driving_rating"] as int?,
        intake: specificMatchTable["intake_rating"] as int?,
        amp: specificMatchTable["amp_rating"] as int?,
        speaker: specificMatchTable["speaker_rating"] as int?,
        climb: specificMatchTable["climb_rating"] as int?,
        defense: specificMatchTable["defense_rating"] as int?,
        general: specificMatchTable["general_rating"] as int?,
        defenseAmount: defenseAmountTitleToEnum(
          specificMatchTable["defense"]["title"] as String,
        ),
        url: specificMatchTable["url"] as String,
      );
}

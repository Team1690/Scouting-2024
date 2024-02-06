import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class SpecificMatchData {
  const SpecificMatchData({
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
    required this.matchIdentifier,
    required this.scheduleMatchId,
  });
  final String scouterNames;
  final int scheduleMatchId;

  final int? drivetrainAndDriving;
  final int? intake;
  final int? speaker;
  final int? amp;
  final int? climb;
  final int? defense;
  final int? general;
  final String url;
  final MatchIdentifier matchIdentifier;
  final DefenseAmount defenseAmount;

  static SpecificMatchData parse(final dynamic specificMatchTable) =>
      SpecificMatchData(
        matchIdentifier: MatchIdentifier.fromJson(specificMatchTable),
        scheduleMatchId: specificMatchTable["schedule_match"]["id"] as int,
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

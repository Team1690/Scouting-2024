import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";

class SpecificMatchData {
  const SpecificMatchData({
    required this.id,
    required this.drivetrainAndDriving,
    required this.intake,
    required this.amp,
    required this.speaker,
    required this.climb,
    required this.defense,
    required this.general,
    required this.matchIdentifier,
    required this.scheduleMatchId,
    required this.scouterName,
  });
  final int scheduleMatchId;
  final int id;
  final int? drivetrainAndDriving;
  final int? intake;
  final int? speaker;
  final int? amp;
  final int? climb;
  final int? defense;
  final int? general;
  final MatchIdentifier matchIdentifier;
  final String scouterName;

  static SpecificMatchData parse(
    final dynamic specificMatchTable,
    final IdProvider idProvider,
  ) =>
      SpecificMatchData(
        id: specificMatchTable["id"] as int,
        matchIdentifier:
            MatchIdentifier.fromJson(specificMatchTable, idProvider.matchType),
        scheduleMatchId: specificMatchTable["schedule_match"]["id"] as int,
        drivetrainAndDriving: specificMatchTable["driving_rating"] as int?,
        intake: specificMatchTable["intake_rating"] as int?,
        amp: specificMatchTable["amp_rating"] as int?,
        speaker: specificMatchTable["speaker_rating"] as int?,
        climb: specificMatchTable["climb_rating"] as int?,
        defense: specificMatchTable["defense_rating"] as int?,
        general: specificMatchTable["general_rating"] as int?,
        scouterName: specificMatchTable["scouter_name"] as String,
      );
}

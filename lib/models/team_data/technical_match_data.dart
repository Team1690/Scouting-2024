import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_data/starting_position_enum.dart";
import "package:scouting_frontend/models/team_data/technical_data.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class TechnicalMatchData {
  TechnicalMatchData({
    required this.scheduleMatchId,
    required this.robotFieldStatus,
    required this.data,
    required this.harmonyWith,
    required this.climb,
    required this.matchIdentifier,
    required this.startingPosition,
  });

  final RobotFieldStatus robotFieldStatus;
  final MatchIdentifier matchIdentifier;
  final TechnicalData<int> data;
  final int harmonyWith;
  final Climb climb;
  final int scheduleMatchId;
  final StartingPosition startingPosition;

  static TechnicalMatchData parse(final dynamic match) => TechnicalMatchData(
        matchIdentifier: MatchIdentifier.fromJson(match),
        robotFieldStatus: robotFieldStatusTitleToEnum(
          match["robot_field_status"]["title"] as String,
        ),
        harmonyWith: match["harmony_with"] as int,
        climb: climbTitleToEnum(match["climb"]["title"] as String),
        scheduleMatchId: match["schedule_match"]["id"] as int,
        data: TechnicalData.parse(match),
        startingPosition: startingPosTitleToEnum(
          match["starting_position"]["title"] as String,
        ),
      );
}

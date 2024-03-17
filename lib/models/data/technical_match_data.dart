import "package:collection/collection.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/data/starting_position_enum.dart";
import "package:scouting_frontend/models/data/technical_data.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";

class TechnicalMatchData {
  TechnicalMatchData({
    required this.scouterName,
    required this.scheduleMatchId,
    required this.robotFieldStatus,
    required this.data,
    required this.harmonyWith,
    required this.climb,
    required this.matchIdentifier,
    required this.startingPosition,
    required this.autoGamepieces,
  });

  final RobotFieldStatus robotFieldStatus;
  final MatchIdentifier matchIdentifier;
  final TechnicalData<int> data;
  final int harmonyWith;
  final Climb climb;
  final int scheduleMatchId;
  final StartingPosition startingPosition;
  final String scouterName;
  final List<(AutoGamepieceID, AutoGamepieceState)> autoGamepieces;

  static List<(AutoGamepieceID, AutoGamepieceState)> parseGamepieces(
    final dynamic match,
    final IdProvider idProvider,
  ) =>
      <(AutoGamepieceID, AutoGamepieceState)>[
        for (final AutoGamepieceID autoGamepieceID in AutoGamepieceID.values)
          (
            autoGamepieceID,
            idProvider.autoGamepieceStates
                .idToEnum[match[autoGamepieceID.title]["id"] as int]!
          ),
      ].sorted((
        final (AutoGamepieceID, AutoGamepieceState) a,
        final (AutoGamepieceID, AutoGamepieceState) b,
      ) {
        final List<String> autoOrder =
            (match["auto_order"] as String).split(",");
        int getIndexInOrder(final AutoGamepieceID element) {
          final int index = autoOrder.indexOf(element.title);
          return index == -1 ? autoOrder.length : index;
        }

        final int aIndex = getIndexInOrder(a.$1);
        final int bIndex = getIndexInOrder(b.$1);

        return bIndex.compareTo(aIndex);
      });

  static TechnicalMatchData parse(
    final dynamic match,
    final IdProvider idProvider,
  ) {
    final List<(AutoGamepieceID, AutoGamepieceState)> gamepieces =
        parseGamepieces(match, idProvider);
    return TechnicalMatchData(
      autoGamepieces: gamepieces,
      matchIdentifier: MatchIdentifier.fromJson(match, idProvider.matchType),
      robotFieldStatus: idProvider
          .robotFieldStatus.idToEnum[match["robot_field_status"]["id"] as int]!,
      harmonyWith: match["harmony_with"] as int,
      //TODO: idprovider climb
      climb: climbTitleToEnum(match["climb"]["title"] as String),
      scheduleMatchId: match["schedule_match"]["id"] as int,
      data: TechnicalData.parse(match, gamepieces),
      startingPosition: idProvider
          .startingPosition.idToEnum[match["starting_position"]["id"] as int]!,
      scouterName: match["scouter_name"] as String,
    );
  }
}

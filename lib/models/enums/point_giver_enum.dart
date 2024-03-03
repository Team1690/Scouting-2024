import "package:scouting_frontend/models/enums/match_mode_enum.dart";
import "package:scouting_frontend/models/enums/place_location_enum.dart";

enum PointGiver {
  autoSpeaker(
    mode: MatchMode.auto,
    place: PlaceLocation.amp,
    points: 5,
  ),
  autoAmp(
    mode: MatchMode.auto,
    place: PlaceLocation.amp,
    points: 2,
  ),
  teleSpeaker(
    mode: MatchMode.tele,
    place: PlaceLocation.speaker,
    points: 2,
  ),
  teleAmp(
    mode: MatchMode.tele,
    place: PlaceLocation.amp,
    points: 1,
  ),
  trap(
    mode: MatchMode.endGame,
    place: PlaceLocation.trap,
    points: 5,
  ),
  climb(
    mode: MatchMode.endGame,
    points: 3,
  );

  const PointGiver({
    required this.mode,
    this.place,
    required this.points,
  });

  final MatchMode mode;
  final PlaceLocation? place;
  final int points;

  num calcPoints(final num amount) => points * amount;
}

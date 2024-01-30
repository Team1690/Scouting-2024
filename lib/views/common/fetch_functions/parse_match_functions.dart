import "package:collection/collection.dart";

enum MatchMode {
  auto("auto"),
  tele("tele");

  const MatchMode(this.title);
  final String title;
}

enum PlaceLocation {
  speaker("speaker"),
  amp("amp"),
  trap("trap");

  const PlaceLocation(this.title);
  final String title;
}

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
    mode: MatchMode.tele,
    place: PlaceLocation.trap,
    points: 5,
  );

  const PointGiver({
    required this.mode,
    required this.place,
    required this.points,
  });

  final MatchMode mode;
  final PlaceLocation place;
  final int points;
}

Map<PointGiver, T> parseByMode<T extends num>(
  final MatchMode mode,
  final dynamic match,
) =>
    Map<PointGiver, T>.fromEntries(
      PointGiver.values
          .where(
            (final PointGiver pointGiver) =>
                pointGiver.mode == mode &&
                pointGiver.place != PlaceLocation.trap,
          )
          .map(
            (final PointGiver pointGiver) => MapEntry<PointGiver, T>(
              pointGiver,
              match["${pointGiver.mode.title}_${pointGiver.place.title}"] as T,
            ),
          ),
    );

Map<PointGiver, T> parseByPlace<T extends num>(
  final PlaceLocation location,
  final dynamic match,
) =>
    Map<PointGiver, T>.fromEntries(
      PointGiver.values
          .where(
            (final PointGiver pointGiver) => pointGiver.place == location,
          )
          .map(
            (final PointGiver pointGiver) => MapEntry<PointGiver, T>(
              pointGiver,
              match["${pointGiver.mode.title}_${pointGiver.place.title}"] as T,
            ),
          ),
    );

Map<PointGiver, T> parseMatch<T extends num>(
  final dynamic match,
) =>
    <PointGiver, T>{
      ...parseByMode<T>(MatchMode.auto, match),
      ...parseByMode<T>(MatchMode.tele, match),
    };

T getPoints<T extends num>(final Map<PointGiver, T> parsedMatch) =>
    PointGiver.values
        .map(
          (final PointGiver pointGiver) => parsedMatch.entries
              .where(
                (final MapEntry<PointGiver, T> match) =>
                    match.key == pointGiver,
              )
              .map(
                (final MapEntry<PointGiver, T> e) => e.key.points * e.value,
              )
              .sum,
        )
        .sum as T;

T getPieces<T extends num>(final Map<PointGiver, T> parsedMatch) =>
    parsedMatch.values.sum as T;

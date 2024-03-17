import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";

class AutoGamepieces {
  AutoGamepieces({
    required this.l0,
    required this.l1,
    required this.l2,
    required this.m0,
    required this.m1,
    required this.m2,
    required this.m3,
    required this.m4,
  });

  AutoGamepieces.base()
      : l1 = AutoGamepieceState.noAttempt,
        l2 = AutoGamepieceState.noAttempt,
        l0 = AutoGamepieceState.noAttempt,
        m0 = AutoGamepieceState.noAttempt,
        m1 = AutoGamepieceState.noAttempt,
        m2 = AutoGamepieceState.noAttempt,
        m3 = AutoGamepieceState.noAttempt,
        m4 = AutoGamepieceState.noAttempt;

  AutoGamepieces.fromMap(
    final Map<AutoGamepieceID, AutoGamepieceState> gamepieces,
  )   : l0 = gamepieces[AutoGamepieceID.one] ?? AutoGamepieceState.noAttempt,
        l1 = gamepieces[AutoGamepieceID.two] ?? AutoGamepieceState.noAttempt,
        l2 = gamepieces[AutoGamepieceID.three] ?? AutoGamepieceState.noAttempt,
        m0 = gamepieces[AutoGamepieceID.four] ?? AutoGamepieceState.noAttempt,
        m1 = gamepieces[AutoGamepieceID.five] ?? AutoGamepieceState.noAttempt,
        m2 = gamepieces[AutoGamepieceID.six] ?? AutoGamepieceState.noAttempt,
        m3 = gamepieces[AutoGamepieceID.seven] ?? AutoGamepieceState.noAttempt,
        m4 = gamepieces[AutoGamepieceID.eight] ?? AutoGamepieceState.noAttempt;

  Map<AutoGamepieceID, AutoGamepieceState> get asMap =>
      <AutoGamepieceID, AutoGamepieceState>{
        AutoGamepieceID.one: l0,
        AutoGamepieceID.two: l1,
        AutoGamepieceID.three: l2,
        AutoGamepieceID.four: m0,
        AutoGamepieceID.five: m1,
        AutoGamepieceID.six: m2,
        AutoGamepieceID.seven: m3,
        AutoGamepieceID.eight: m4,
      };

  final AutoGamepieceState l0;
  final AutoGamepieceState l1;
  final AutoGamepieceState l2;
  final AutoGamepieceState m0;
  final AutoGamepieceState m1;
  final AutoGamepieceState m2;
  final AutoGamepieceState m3;
  final AutoGamepieceState m4;
}

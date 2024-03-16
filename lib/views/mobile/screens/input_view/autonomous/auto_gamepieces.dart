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
      : l1 = AutoGamepieceState.notTaken,
        l2 = AutoGamepieceState.notTaken,
        l0 = AutoGamepieceState.notTaken,
        m0 = AutoGamepieceState.notTaken,
        m1 = AutoGamepieceState.notTaken,
        m2 = AutoGamepieceState.notTaken,
        m3 = AutoGamepieceState.notTaken,
        m4 = AutoGamepieceState.notTaken;

  AutoGamepieces.fromMap(
    final Map<AutoGamepieceID, AutoGamepieceState> gamepieces,
  )   : l0 = gamepieces[AutoGamepieceID.one] ?? AutoGamepieceState.notTaken,
        l1 = gamepieces[AutoGamepieceID.two] ?? AutoGamepieceState.notTaken,
        l2 = gamepieces[AutoGamepieceID.three] ?? AutoGamepieceState.notTaken,
        m0 = gamepieces[AutoGamepieceID.four] ?? AutoGamepieceState.notTaken,
        m1 = gamepieces[AutoGamepieceID.five] ?? AutoGamepieceState.notTaken,
        m2 = gamepieces[AutoGamepieceID.six] ?? AutoGamepieceState.notTaken,
        m3 = gamepieces[AutoGamepieceID.seven] ?? AutoGamepieceState.notTaken,
        m4 = gamepieces[AutoGamepieceID.eight] ?? AutoGamepieceState.notTaken;

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

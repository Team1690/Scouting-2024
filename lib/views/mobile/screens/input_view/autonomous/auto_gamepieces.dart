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
        l1 = gamepieces[AutoGamepieceID.one] ?? AutoGamepieceState.notTaken,
        l2 = gamepieces[AutoGamepieceID.one] ?? AutoGamepieceState.notTaken,
        m0 = gamepieces[AutoGamepieceID.one] ?? AutoGamepieceState.notTaken,
        m1 = gamepieces[AutoGamepieceID.one] ?? AutoGamepieceState.notTaken,
        m2 = gamepieces[AutoGamepieceID.one] ?? AutoGamepieceState.notTaken,
        m3 = gamepieces[AutoGamepieceID.one] ?? AutoGamepieceState.notTaken,
        m4 = gamepieces[AutoGamepieceID.one] ?? AutoGamepieceState.notTaken;

  final AutoGamepieceState l0;
  final AutoGamepieceState l1;
  final AutoGamepieceState l2;
  final AutoGamepieceState m0;
  final AutoGamepieceState m1;
  final AutoGamepieceState m2;
  final AutoGamepieceState m3;
  final AutoGamepieceState m4;
}

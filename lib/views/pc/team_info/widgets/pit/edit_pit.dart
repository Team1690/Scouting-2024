import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_vars.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_view.dart";
import "package:scouting_frontend/models/data/pit_data/pit_data.dart";

class EditPit extends StatefulWidget {
  const EditPit(
    this.initialVars,
  );
  final PitData initialVars;
  @override
  State<EditPit> createState() => _EditPitState();
}

class _EditPitState extends State<EditPit> {
  late PitVars vars = fromPitData(widget.initialVars);

  PitVars fromPitData(
    final PitData? pit,
  ) {
    PitVars vars = PitVars(context);
    if (pit == null) {
      return vars;
    }
    vars = vars.copyWith(
      driveMotorType: () => pit.driveMotorType,
      driveTrainType: () => pit.driveTrainType,
      notes: () => pit.notes,
      teamId: () => pit.team.id,
      weight: () => pit.weight,
      length: () => pit.length,
      width: () => pit.width,
      harmony: () => pit.harmony,
      trap: () => pit.trap,
      url: () => pit.url,
      canEject: () => pit.canEject,
      canPassUnderStage: () => pit.canPassUnderStage,
      allRangeShooting: () => pit.allRangeShooting,
    );

    return vars;
  }

  @override
  Widget build(final BuildContext context) => PitView(vars);
}

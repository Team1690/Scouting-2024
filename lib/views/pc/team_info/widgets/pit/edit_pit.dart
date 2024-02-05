import "package:flutter/material.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_vars.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_view.dart";
import 'package:scouting_frontend/models/team_data/pit_data/pit_data.dart';

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
      driveMotorAmount: () => pit.driveMotorAmount,
      driveMotorType: () =>
          IdProvider.of(context).drivemotor.nameToId[pit.driveMotorType.title],
      driveTrainType: () =>
          IdProvider.of(context).driveTrain.nameToId[pit.driveTrainType.title],
      driveWheelType: () =>
          IdProvider.of(context).driveWheel.nameToId[pit.driveWheelType.title],
      gearboxPurchased: () => pit.gearboxPurchased,
      hasShifter: () => pit.hasShifer,
      notes: () => pit.notes,
      teamId: () => pit.team.id,
      weight: () => pit.weight,
      height: () => pit.height,
      harmony: () => pit.harmony,
      trap: () => pit.trap,
      hasBuddyClimb: () => pit.hasBuddyClimb,
    );

    return vars;
  }

  @override
  Widget build(final BuildContext context) => PitView(vars);
}

import "package:flutter/material.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/views/mobile/pit_vars.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_view.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

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
    final PitVars vars = PitVars();
    if (pit == null) {
      return vars;
    }
    //TODO add season specific vars
    vars.driveMotorAmount = pit.driveMotorAmount;
    vars.driveMotorType =
        IdProvider.of(context).drivemotor.nameToId[pit.driveMotorType];
    vars.driveTrainType =
        IdProvider.of(context).driveTrain.nameToId[pit.driveTrainType];
    vars.driveWheelType = pit.driveWheelType;
    vars.gearboxPurchased = pit.gearboxPurchased;
    vars.hasShifter = pit.hasShifer;
    vars.notes = pit.notes;
    vars.teamId = pit.team.id;
    vars.weight = pit.weight.toString();
    return vars;
  }

  @override
  Widget build(final BuildContext context) => PitView(vars);
}

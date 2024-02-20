import "package:flutter/material.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";

class HarmonyIcon extends StatelessWidget {
  const HarmonyIcon({
    super.key,
    required this.pickListTeam,
  });

  final AllTeamData pickListTeam;

  @override
  Widget build(final BuildContext context) => Icon(
        pickListTeam.harmony
            ? Icons.verified_rounded
            : (pickListTeam.pitData != null
                    ? pickListTeam.pitData!.harmony
                    : false)
                ? Icons.check_circle_outline_rounded
                : Icons.unpublished_outlined,
        color: pickListTeam.harmony
            ? const Color.fromARGB(255, 61, 135, 238)
            : (pickListTeam.pitData != null
                    ? pickListTeam.pitData!.harmony
                    : false)
                ? const Color.fromARGB(
                    255,
                    161,
                    255,
                    135,
                  )
                : Colors.amber,
      );
}

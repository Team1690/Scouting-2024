import "package:flutter/material.dart";
import "package:scouting_frontend/models/team_info_models/quick_data.dart";

class CoachQuickData extends StatelessWidget {
  const CoachQuickData(this.data);
  final QuickData data;

  @override
  Widget build(final BuildContext context) => data.amoutOfMatches == 0
      ? const Center(child: Text("No data :("))
      : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          primary: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //TODO add quickdata ui here
              const Text(
                "Amp",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Median Auto Amp: ${data.medianData.autoAmp.toStringAsFixed(2)}",
              ),
              Text(
                "Median Tele Amp: ${data.medianData.teleAmp.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Auto Amp: ${data.avgData.autoAmp.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Tele Amp: ${data.avgData.autoSpeaker.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Total Amp: ${(data.avgData.ampGamepieces).toStringAsFixed(2)}",
              ),
              Text(
                "Max Total Amp: ${(data.maxData.ampGamepieces).toStringAsFixed(2)}",
              ),
              Text(
                "Min Total Amp: ${data.minData.ampGamepieces.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Auto Amp Missed: ${data.avgData.autoAmpMissed.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Tele Amp Missed ${data.avgData.teleAmpMissed.toStringAsFixed(2)}",
              ),
              Text(
                "Median auto Amp Missed: ${data.medianData.autoAmpMissed.toStringAsFixed(2)}",
              ),
              Text(
                "Median Tele Amp Missed: ${data.medianData.teleAmpMissed.toStringAsFixed(2)}",
              ),
              const Text(
                "Speaker",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Median Auto Speaker: ${data.medianData.autoSpeaker.toStringAsFixed(2)}",
              ),
              Text(
                "Median Tele Speaker: ${data.medianData.teleSpeaker.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Auto Speaker: ${data.avgData.autoSpeaker.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Tele Speaker: ${data.avgData.teleSpeaker.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Total Speaker: ${data.avgData.speakerGamepieces.toStringAsFixed(2)}",
              ),
              Text(
                "Max Total Speaker: ${(data.maxData.speakerGamepieces).toStringAsFixed(2)}",
              ),
              Text(
                "Min Total Speaker: ${data.minData.speakerGamepieces.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Auto Speaker Missed: ${data.avgData.autoSpeakerMissed.toStringAsFixed(2)}",
              ),
              Text(
                "Avg Tele Speaker Missed ${data.avgData.teleSpeakerMissed.toStringAsFixed(2)}",
              ),
              Text(
                "Median auto Speaker Missed: ${data.medianData.autoSpeakerMissed.toStringAsFixed(2)}",
              ),
              Text(
                "Median Tele Speaker Missed: ${data.medianData.teleSpeakerMissed.toStringAsFixed(2)}",
              ),
              const Text(
                "Climb",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Climb Percentage: ${data.climbPercentage.isNaN ? "No Data" : data.climbPercentage.toStringAsFixed(1)}%",
              ),
              Text(
                "Can Harmony: ${data.canHarmony ?? "No Data"}",
              ),
              Text(
                "Matches Climbed 1: ${data.matchesClimbedSingle}",
              ),
              Text(
                "Matches Climbed 2: ${data.matchesClimbedDouble}",
              ),
              Text(
                "Matches Climbed 3: ${data.matchesClimbedTriple}",
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Misc",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(
                "Median Gamepiece Points: ${data.medianData.gamePiecesPoints.toStringAsFixed(1)}",
              ),
              Text(
                "Median Gamepiece: ${data.medianData.gamepieces.toStringAsFixed(1)}",
              ),
              Text(
                "Avg Gamepiece Points: ${data.gamepiecePoints.toStringAsFixed(1)}",
              ),
              Text(
                "Avg Gamepieces: ${data.gamepiecesScored.toStringAsFixed(1)}",
              ),
              Text(
                "Possible Traps: ${data.trapAmount ?? "No Data"}",
              ),
              Text(
                "Avg Trap Amount: ${data.avgData.trapAmount.toStringAsFixed(1)}",
              ),
              Text(
                "Trap Success Rate: ${data.trapSuccessRate.isNaN ? "No Data" : "${data.trapSuccessRate.toStringAsFixed(1)}%"}",
              ),
              Text(
                "Median Trap Amount: ${data.medianData.trapAmount}",
              ),
              Text(
                textAlign: TextAlign.center,
                "Matches Played: ${data.amoutOfMatches}",
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Picklist",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                "First: ${data.firstPicklistIndex + 1}",
              ),
              Text(
                textAlign: TextAlign.center,
                "Second: ${data.secondPicklistIndex + 1}",
              ),
              Text(
                textAlign: TextAlign.center,
                "Second: ${data.thirdPicklistIndex + 1}",
              ),
            ],
          ),
        );
}

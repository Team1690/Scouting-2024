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
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Auto",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Teleop",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Points",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Misc",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                "Matches Played: ${data.amoutOfMatches}",
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Defense Stats",
                  style: TextStyle(fontSize: 18),
                ),
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
            ],
          ),
        );
}

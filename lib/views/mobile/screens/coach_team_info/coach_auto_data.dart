import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";

class CoachAutoData extends StatelessWidget {
  const CoachAutoData(this.data);
  final AutoData data;

  @override
  Widget build(final BuildContext context) => CarouselWithIndicator(
        direction: Axis.vertical,
        enableInfininteScroll: true,
        initialPage: 0,
        widgets: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "slot 1", //TODO rename
                  style: TextStyle(fontSize: 18),
                ),
              ),
              data.slot1Data.amoutOfMatches == 0
                  ? const Center(child: Text("No data"))
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[], //TODO add season specific data
                    ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "slot 2", //TODO rename
                  style: TextStyle(fontSize: 18),
                ),
              ),
              data.slot2Data.amoutOfMatches == 0
                  ? const Center(child: Text("No data"))
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[], //TODO add season specific data
                    ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "slot 3", //TODO rename
                  style: TextStyle(fontSize: 18),
                ),
              ),
              data.slot3Data.amoutOfMatches == 0
                  ? const Center(child: Text("No data"))
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[], //TODO add season specific data
                    ),
            ],
          ),
        ],
      );
}

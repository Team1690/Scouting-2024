import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/pc/picklist/auto_picklist_popup.dart";

class ValueSliders extends StatefulWidget {
  const ValueSliders({required this.onButtonPress});
  final Function(AutoPicklistResult) onButtonPress;

  @override
  State<ValueSliders> createState() => _ValueSlidersState();
}

class _ValueSlidersState extends State<ValueSliders> {
  double ampFactor = 0.5;
  double speakerFactor = 0.5;
  double climbFactor = 0.0;
  bool filterSwerve = true;
  @override
  Widget build(final BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SectionDivider(label: "Climb Percentage"),
          ...<Widget>[
            Slider(
              value: climbFactor,
              onChanged: (final double newValue) => setState(() {
                climbFactor = newValue;
              }),
            ),
            SectionDivider(label: "Amp Points"),
            Slider(
              value: ampFactor,
              onChanged: (final double newValue) => setState(() {
                ampFactor = newValue;
              }),
            ),
            SectionDivider(label: "Speaker Points"),
            Slider(
              value: speakerFactor,
              onChanged: (final double newValue) => setState(() {
                speakerFactor = newValue;
              }),
            ),
          ],
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          RoundedIconButton(
            color: Colors.green,
            onPress: () => widget.onButtonPress(
              (
                climbFactor: climbFactor,
                ampFactor: ampFactor,
                speakerFactor: speakerFactor,
                filterSwerve: filterSwerve,
              ),
            ),
            onLongPress: () => widget.onButtonPress(
              (
                climbFactor: climbFactor,
                ampFactor: ampFactor,
                speakerFactor: speakerFactor,
                filterSwerve: filterSwerve,
              ),
            ),
            icon: Icons.calculate_outlined,
          ),
        ],
      );
}

import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";

class ValueSliders extends StatefulWidget {
  const ValueSliders({required this.onButtonPress});
//TODO rename to season specific vars
  final Function(
    double climbSlider,
    double ampSlider,
    double speakerSlider,
    double trapSlider,
  ) onButtonPress;

  @override
  State<ValueSliders> createState() => _ValueSlidersState();
}

class _ValueSlidersState extends State<ValueSliders> {
  //TODO rename to season specific vars
  double climbFactor = 0.5;
  double ampFactor = 0.5;
  double speakerFactor = 0.5;
  double trapFactor = 0.5;
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
            SectionDivider(label: "Traps"),
            Slider(
              value: trapFactor,
              onChanged: (final double newValue) => setState(() {
                trapFactor = newValue;
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
              climbFactor,
              ampFactor,
              speakerFactor,
              trapFactor,
            ),
            icon: Icons.calculate_outlined,
            onLongPress: () => widget.onButtonPress(
              climbFactor,
              ampFactor,
              speakerFactor,
              trapFactor,
            ),
          ),
        ],
      );
}

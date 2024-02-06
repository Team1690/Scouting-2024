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
    bool filter1,
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
  bool filter1 = false;
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
          SectionDivider(label: "Filters"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //TODO add more filters if needed
              ToggleButtons(
                children: const <Text>[Text("Filter Feeder")],
                isSelected: <bool>[filter1],
                onPressed: (final int unused) => setState(() {
                  filter1 = !filter1;
                }),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          RoundedIconButton(
            color: Colors.green,
            onPress: () => widget.onButtonPress(
              ampFactor,
              climbFactor,
              speakerFactor,
              trapFactor,
              filter1,
            ),
            icon: Icons.calculate_outlined,
            onLongPress: () => widget.onButtonPress(
              ampFactor,
              climbFactor,
              speakerFactor,
              trapFactor,
              filter1,
            ),
          ),
        ],
      );
}

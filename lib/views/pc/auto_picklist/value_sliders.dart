import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";

class ValueSliders extends StatefulWidget {
  const ValueSliders({required this.onButtonPress});
//TODO rename to season specific vars
  final Function(
    double slider0,
    double slider1,
    double slider2,
    bool filter1,
  ) onButtonPress;

  @override
  State<ValueSliders> createState() => _ValueSlidersState();
}

class _ValueSlidersState extends State<ValueSliders> {
  //TODO rename to season specific vars
  double factor1 = 0.5;
  double factor2 = 0.5;
  double factor3 = 0.5;
  bool filter1 = false;
  @override
  Widget build(final BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SectionDivider(label: "GamePiece Sum"),
          ...<Widget>[
            Slider(
              value: factor1,
              onChanged: (final double newValue) => setState(() {
                factor1 = newValue;
              }),
            ),
            SectionDivider(label: "GamePiece Points"),
            Slider(
              value: factor2,
              onChanged: (final double newValue) => setState(() {
                factor2 = newValue;
              }),
            ),
            SectionDivider(label: "Auto Balance Points"),
            Slider(
              value: factor3,
              onChanged: (final double newValue) => setState(() {
                factor3 = newValue;
              }),
            ),
          ].expand(
            (final Widget element) => <Widget>[
              const SizedBox(
                height: 10,
              ),
              element,
            ],
          ),
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
              factor2,
              factor1,
              factor3,
              filter1,
            ),
            icon: Icons.calculate_outlined,
            onLongPress: () => widget.onButtonPress(
              factor2,
              factor1,
              factor3,
              filter1,
            ),
          ),
        ],
      );
}

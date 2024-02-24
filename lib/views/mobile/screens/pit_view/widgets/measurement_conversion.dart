import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/pit_view/pit_view.dart";

class MeasurementConversion extends StatelessWidget {
  const MeasurementConversion({
    super.key,
    required this.controller,
    required this.title,
    required this.unitTypes,
    required this.regularUnitsToOtherUnitsFactor,
    required this.onValueChange,
    required this.onRegularUnits,
    required this.currentValue,
    required this.onUnitsChange,
    required this.icon,
  });

  final TextEditingController controller;
  final String title;
  final IconData icon;
  final List<String> unitTypes;
  final double regularUnitsToOtherUnitsFactor;
  final bool onRegularUnits;
  final void Function(double?) onValueChange;
  final void Function(bool) onUnitsChange;
  final double? currentValue;

  @override
  Widget build(final BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller,
              onChanged: (final String weight) {
                onValueChange(
                  double.tryParse(weight).mapNullable(
                    (final double parsedWeight) =>
                        parsedWeight *
                        (onRegularUnits
                            ? 1
                            : 1 / regularUnitsToOtherUnitsFactor),
                  ),
                );
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: title,
                prefixIcon: Icon(icon),
              ),
              validator: numericValidator(
                "please enter the robot's $title",
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            flex: 2,
            child: Switcher(
              height: 60,
              labels: unitTypes,
              colors: const <Color>[
                Colors.white,
                Colors.white,
              ],
              onChange: (final int selection) {
                final bool newSelection =
                    <int, bool>{1: false, 0: true}[selection]!;
                final String newText = currentValue
                        .mapNullable(
                          (final double weight) =>
                              weight *
                              (newSelection
                                  ? 1
                                  : regularUnitsToOtherUnitsFactor),
                        )
                        ?.toString() ??
                    "";
                controller.text = newText;

                onUnitsChange(newSelection);
              },
              selected: onRegularUnits ? 0 : 1,
              borderRadiusGeometry: defaultBorderRadius,
            ),
          ),
        ],
      );
}

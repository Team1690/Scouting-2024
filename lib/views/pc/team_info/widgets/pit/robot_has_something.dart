import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class RobotHasSomething extends StatelessWidget {
  const RobotHasSomething({
    required this.title,
    required this.value,
    this.numeralValue,
  });
  final bool? value;
  final String title;
  final int? numeralValue;
  @override
  Widget build(final BuildContext context) => Row(
        children: <Widget>[
          Text(textAlign: TextAlign.center, title),
          value.mapNullable(
                (final bool hasSomething) => hasSomething
                    ? numeralValue == null
                        ? const Icon(
                            Icons.done,
                            color: Colors.lightGreen,
                          )
                        : Text("$numeralValue")
                    : const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
              ) ??
              const Text(" Not answered"),
        ],
      );
}

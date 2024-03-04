import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";

class StatusBox extends StatelessWidget {
  const StatusBox({required this.child, this.backgroundColor});
  final Widget child;
  final Color? backgroundColor;
  @override
  Widget build(final BuildContext context) => Container(
        width: 80,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(
          defaultPadding / 3,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: primaryWhite,
            width: 1,
          ),
          borderRadius: defaultBorderRadius / 2,
        ),
        child: child,
      );
}

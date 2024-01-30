import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";

class PathCanvas extends StatelessWidget {
  const PathCanvas({
    super.key,
    required this.sketch,
    required this.fieldImages,
  });
  final Sketch sketch;

  final (ui.Image, ui.Image) fieldImages;

  @override
  Widget build(final BuildContext context) => AspectRatio(
        aspectRatio: autoFieldWidth / fieldheight,
        child: LayoutBuilder(
          builder: (
            final BuildContext context,
            final BoxConstraints constraints,
          ) =>
              CustomPaint(
            painter: DrawingCanvas(
              width: 3,
              fieldBackground: sketch.isRed ? fieldImages.$1 : fieldImages.$2,
              sketch: Sketch(
                isRed: sketch.isRed,
                url: sketch.url,
                points: sketch.points
                    .map(
                      (final ui.Offset e) => e.scale(
                        constraints.maxWidth / autoFieldWidth,
                        constraints.maxWidth / autoFieldWidth,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      );
}

import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";

class SelectPath extends StatefulWidget {
  const SelectPath({required this.pathes, required this.fieldBackground});
  final List<List<Offset>> pathes;
  final ui.Image fieldBackground;

  @override
  State<SelectPath> createState() => _SelectPathState();
}

class _SelectPathState extends State<SelectPath> {
  @override
  Widget build(final BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ...widget.pathes
                  .map(
                    (final List<ui.Offset> path) => AspectRatio(
                      aspectRatio: autoFieldWidth / fieldheight,
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: DrawingCanvas(
                            fieldBackground: widget.fieldBackground,
                            sketch: Sketch(points: path),
                          ),
                        ),
                      ),
                    ),
                  )
                  .expand(
                    (final AspectRatio element) => <Widget>[
                      element,
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
              ElevatedButton(
                onPressed: () {
                  final String csvString = widget.pathes.first
                      .map((final ui.Offset e) => "${e.dx},${e.dy}")
                      .join("\n");
                  print(csvString);
                },
                child: const Text("Select Sketched Path"),
              ),
            ],
          ),
        ),
      );
}

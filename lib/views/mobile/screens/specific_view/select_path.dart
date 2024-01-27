import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";

class SelectPath extends StatefulWidget {
  const SelectPath({
    required this.newPath,
    required this.existingPaths,
    required this.fieldBackground,
    required this.onSelectExistingPath,
    required this.onNewSelected,
  });
  final List<(List<Offset>, String)> existingPaths;
  final List<Offset> newPath;
  final ui.Image fieldBackground;
  final void Function(String) onSelectExistingPath;
  final void Function(String) onNewSelected;

  @override
  State<SelectPath> createState() => _SelectPathState();
}

class _SelectPathState extends State<SelectPath> {
  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ...widget.existingPaths
                        .map(
                          (final (List<ui.Offset>, String) path) => AspectRatio(
                            aspectRatio: autoFieldWidth / fieldheight,
                            child: LayoutBuilder(
                              builder: (
                                final BuildContext context,
                                final BoxConstraints constraints,
                              ) =>
                                  GestureDetector(
                                onTap: () {
                                  widget.onSelectExistingPath(path.$2);
                                },
                                child: CustomPaint(
                                  painter: DrawingCanvas(
                                    width: 3,
                                    fieldBackground: widget.fieldBackground,
                                    sketch: Sketch(
                                      points: path.$1
                                          .map(
                                            (final ui.Offset e) =>
                                                Offset(e.dx, e.dy),
                                          )
                                          .map(
                                            (final ui.Offset e) => e.scale(
                                              constraints.maxWidth /
                                                  autoFieldWidth,
                                              constraints.maxWidth /
                                                  autoFieldWidth,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
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
                        final String csvString = widget.newPath
                            .map((final ui.Offset e) => "${e.dx},${e.dy}")
                            .join("\n");
                        widget.onNewSelected(csvString);
                      },
                      child: const Text("Select Sketched Path"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

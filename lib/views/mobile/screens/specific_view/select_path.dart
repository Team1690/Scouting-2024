import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";
import "package:scouting_frontend/views/common/auto_path/path_canvas.dart";

class SelectPath extends StatefulWidget {
  const SelectPath({
    required this.existingPaths,
    required this.fieldBackgrounds,
    required this.onNewSketch,
  });
  final List<Sketch> existingPaths;
  final (ui.Image, ui.Image) fieldBackgrounds;
  final void Function(Sketch) onNewSketch;

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
                          (final Sketch path) => GestureDetector(
                            onTap: () {
                              widget.onNewSketch(path);
                            },
                            child: AspectRatio(
                              aspectRatio: autoFieldWidth / fieldheight,
                              child: LayoutBuilder(
                                builder: (
                                  final BuildContext context,
                                  final BoxConstraints constraints,
                                ) =>
                                    PathCanvas(
                                  sketch: path,
                                  fieldImages: widget.fieldBackgrounds,
                                ),
                              ),
                            ),
                          ),
                        )
                        .expand(
                          (final Widget element) => <Widget>[
                            element,
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

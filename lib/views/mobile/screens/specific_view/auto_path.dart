import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/select_path.dart";

class AutoPath extends StatefulWidget {
  const AutoPath({
    required this.fieldBackgrounds,
    required this.existingPaths,
    required this.initialPath,
    required this.initialIsRed,
  });
  final (ui.Image, ui.Image) fieldBackgrounds;
  final List<Sketch> existingPaths;
  final Sketch? initialPath;
  final bool initialIsRed;

  @override
  State<AutoPath> createState() => _AutoPathState();
}

class _AutoPathState extends State<AutoPath> {
  late final ValueNotifier<Sketch> path = ValueNotifier<Sketch>(
    widget.initialPath ??
        Sketch(
          points: <ui.Offset>[],
          isRed: widget.initialIsRed,
          url: null,
        ),
  );
  bool pathDone = false;
  double rescaleRatio = 0;
  @override
  void didChangeDependencies() {
    rescaleRatio = autoFieldWidth / MediaQuery.of(context).size.width;
    path.value = Sketch(
      url: path.value.url,
      points: path.value.points
          .map(
            (final ui.Offset spot) => spot.scale(
              1 / rescaleRatio,
              1 / rescaleRatio,
            ),
          )
          .toList(),
      isRed: path.value.isRed,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width *
                  fieldheight /
                  autoFieldWidth,
              child: LayoutBuilder(
                builder: (
                  final BuildContext context,
                  final BoxConstraints constraints,
                ) =>
                    Listener(
                  onPointerDown: (final PointerDownEvent pointerEvent) {
                    if (!pathDone) {
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      final Offset offset =
                          box.globalToLocal(pointerEvent.position);
                      path.value = Sketch(
                        points: <Offset>[offset],
                        isRed: path.value.isRed,
                        url: path.value.url,
                      );
                    }
                  },
                  onPointerMove: (final PointerMoveEvent pointerEvent) {
                    if (!pathDone &&
                        pointerEvent.position.dy -
                                AppBar().preferredSize.height <
                            constraints.maxHeight) {
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      final Offset offset =
                          box.globalToLocal(pointerEvent.position);
                      final List<Offset> points =
                          List<Offset>.from(path.value.points)..add(offset);

                      path.value = Sketch(
                        points: points,
                        isRed: path.value.isRed,
                        url: path.value.url,
                      );
                    }
                  },
                  onPointerUp: (final PointerUpEvent pointerUpEvent) {
                    pathDone = true;
                  },
                  child: ListenableBuilder(
                    listenable: path,
                    builder: (final BuildContext context, final Widget? e) =>
                        RepaintBoundary(
                      child: LayoutBuilder(
                        builder: (
                          final BuildContext context,
                          final BoxConstraints constraints,
                        ) =>
                            CustomPaint(
                          painter: DrawingCanvas(
                            sketch: path.value,
                            fieldBackground: path.value.isRed
                                ? widget.fieldBackgrounds.$1
                                : widget.fieldBackgrounds.$2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    if (pathDone) {
                      path.value = Sketch(
                        points: <Offset>[],
                        isRed: path.value.isRed,
                        url: path.value.url,
                      );
                      pathDone = false;
                    }
                  },
                  icon: const Icon(Icons.delete_outline_rounded),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (final BuildContext dialogContext) => SelectPath(
                        fieldBackgrounds: widget.fieldBackgrounds,
                        drawnPath: Sketch(
                          isRed: path.value.isRed,
                          points: path.value.points
                              .map(
                                (final ui.Offset e) => e.scale(
                                  rescaleRatio,
                                  rescaleRatio,
                                ),
                              )
                              .toList(),
                          url: path.value.url,
                        ),
                        existingPaths: widget.existingPaths,
                        onNewSketch: (final Sketch sketch) {
                          Navigator.pop(context);
                          Navigator.pop(context, sketch);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_as),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                  onPressed: () => setState(() {
                    path.value = Sketch(
                      isRed: !path.value.isRed,
                      points: path.value.points,
                      url: path.value.url,
                    );
                  }),
                  icon: const Icon(Icons.flip_camera_android),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      path.value.isRed ? Colors.blue : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class DrawingCanvas extends CustomPainter {
  DrawingCanvas({
    required this.sketch,
    required this.fieldBackground,
    this.width = 6.0,
  });
  final Sketch? sketch;
  final ui.Image fieldBackground;
  final double width;

  @override
  void paint(final Canvas canvas, final ui.Size size) async {
    canvas.drawImageRect(
      fieldBackground,
      Rect.fromLTWH(
        0,
        0,
        fieldBackground.width.toDouble(),
        fieldBackground.height.toDouble(),
      ),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
    final List<Offset> points = sketch?.points ?? <ui.Offset>[];
    if (points.isNotEmpty) {
      final Path path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      points
          .take(points.length - 1)
          .forEachIndexed((final int index, final Offset element) {
        final Offset nextPoint = points[index + 1];
        path.quadraticBezierTo(
          element.dx,
          element.dy,
          (nextPoint.dx + element.dx) / 2,
          (nextPoint.dy + element.dy) / 2,
        );
      });
      final Paint paint = Paint()
        ..color = Colors.white
        ..strokeCap = StrokeCap.round
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant final DrawingCanvas oldDelegate) => true;
}

class Sketch {
  Sketch({
    required this.points,
    required this.isRed,
    required this.url,
  });
  final List<Offset> points;
  final bool isRed;
  final String? url;
}

import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/csv_or_url.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/select_path.dart";

class AutoPath extends StatefulWidget {
  const AutoPath({
    required this.fieldBackground,
    required this.onChange,
    required this.existingPaths,
    required this.savedPath,
  });
  final ui.Image fieldBackground;
  final void Function(CsvOrUrl) onChange;
  final List<(List<Offset>, String)> existingPaths;
  final List<Offset>? savedPath;

  @override
  State<AutoPath> createState() => _AutoPathState();
}

class _AutoPathState extends State<AutoPath> {
  List<Offset> exportedPath = <ui.Offset>[];
  final ValueNotifier<Sketch> path =
      ValueNotifier<Sketch>(Sketch(points: <Offset>[]));
  bool pathDone = false;
  @override
  void didChangeDependencies() {
    if (widget.savedPath != null) {
      path.value = Sketch(
        points: widget.savedPath!
            .map(
              (final ui.Offset spot) => spot.scale(
                MediaQuery.of(context).size.width / autoFieldWidth,
                MediaQuery.of(context).size.width / autoFieldWidth,
              ),
            )
            .toList(),
      );
      pathDone = true;
    }
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
                      path.value = Sketch(points: <Offset>[offset]);
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
                      path.value = Sketch(points: points);
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
                            fieldBackground: widget.fieldBackground,
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
                      path.value = Sketch(points: <Offset>[]);
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
                    exportedPath = path.value.points
                        .map(
                          (final ui.Offset e) => e.scale(
                            autoFieldWidth / MediaQuery.of(context).size.width,
                            autoFieldWidth / MediaQuery.of(context).size.width,
                          ),
                        )
                        .toList();
                    await showDialog(
                      context: context,
                      builder: (final BuildContext dialogContext) => SelectPath(
                        fieldBackground: widget.fieldBackground,
                        newPath: exportedPath,
                        existingPaths: widget.existingPaths,
                        onSelectExistingPath: (final String url) {
                          Navigator.pop(context);
                          widget.onChange(Url(url: url));
                          Navigator.pop(context);
                        },
                        onNewSelected: (final String csv) {
                          Navigator.pop(context);
                          widget.onChange(Csv(csv: csv));
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_as),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blue,
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
  void paint(final Canvas canvas, final Size size) async {
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
  Sketch({required this.points});
  final List<Offset> points;
}

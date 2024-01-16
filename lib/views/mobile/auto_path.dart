import "package:collection/collection.dart";
import "package:flutter/material.dart";

class AutoPath extends StatefulWidget {
  const AutoPath({super.key});

  @override
  State<AutoPath> createState() => _AutoPathState();
}

class _AutoPathState extends State<AutoPath> {
  @override
  Widget build(final BuildContext context) {
    final ValueNotifier<Sketch> path =
        ValueNotifier<Sketch>(Sketch(points: <Offset>[]));
    bool pathDone = false;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Builder(
            builder: (final BuildContext context) => Container(
              width: 1000,
              height: 500,
              color: Colors.white,
              child: Listener(
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
                  if (!pathDone) {
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
                  builder: (final BuildContext context, final Widget? widget) =>
                      RepaintBoundary(
                    child: CustomPaint(
                      painter: DrawingCanvas(sketch: path.value),
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
            ],
          ),
        ],
      ),
    );
  }
}

class DrawingCanvas extends CustomPainter {
  DrawingCanvas({required this.sketch});
  final Sketch sketch;

  @override
  void paint(final Canvas canvas, final Size size) {
    final List<Offset> points = sketch.points;
    if (points.isEmpty) return;

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
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant final DrawingCanvas oldDelegate) => true;
}

class Sketch {
  Sketch({required this.points});
  final List<Offset> points;
}

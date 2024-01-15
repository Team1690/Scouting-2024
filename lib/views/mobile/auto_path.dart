import "dart:async";
import "dart:typed_data";

import "package:flutter/material.dart";
import "dart:ui" as ui;

import "package:flutter/services.dart";

class AutoPath extends StatefulWidget {
  const AutoPath({super.key});

  @override
  State<AutoPath> createState() => _AutoPathState();
}

class _AutoPathState extends State<AutoPath> {
  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              child: Container(
                color: Colors.amber,
                height: 100,
                width: 100,
                child: CustomPaint(
                  painter: DrawingCanvas(),
                  size: Size(100, 100),
                ),
              ),
            ),
          ],
        ),
      );
}

class DrawingCanvas extends CustomPainter {
  Future<ui.Image> load(final String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromList(Uint8List.view(data.buffer), completer.complete);
    return completer.future;
  }

  @override
  void paint(final Canvas canvas, final Size size) async {
    paintImage(
      canvas: canvas,
      fit: BoxFit.fill,
      rect: Rect.fromPoints(Offset.zero, size.bottomLeft(Offset.zero)),
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
      image: await load("lib/assets/frc_2024_field.png"),
    );
    paintZigZag(canvas, Paint(), Offset.zero, Offset(50, 50), 2, 8);
  }

  @override
  bool shouldRepaint(covariant final DrawingCanvas oldDelegate) => true;
}

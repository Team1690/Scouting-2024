import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/views/pc/auto_gamepieces/auto_gamepieces_view.dart";

class AutoFieldCanvas extends CustomPainter {
  AutoFieldCanvas({
    required this.fieldBackground,
    required this.gamepieceOrder,
    required this.meterToPixelRatio,
  });
  final ui.Image fieldBackground;
  final List<AutoGamepieceID> gamepieceOrder;
  final double meterToPixelRatio;

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

    for (int i = 0; i < gamepieceOrder.length; i++) {
      final TextPainter frontTextPainter = TextPainter(
        text: TextSpan(
          text: i.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      frontTextPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      frontTextPainter.paint(
        canvas,
        notesPlacements.entries
            .firstWhereOrNull(
              (final MapEntry<ui.Offset, AutoGamepieceID> element) =>
                  element.value == gamepieceOrder[i],
            )!
            .key
            .scale(meterToPixelRatio, meterToPixelRatio),
      );
    }
  }

  @override
  bool shouldRepaint(covariant final AutoFieldCanvas oldDelegate) => true;
}

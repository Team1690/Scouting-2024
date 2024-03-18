import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/auto_gamepieces/auto_field_canvas.dart";
import "package:scouting_frontend/views/pc/auto_gamepieces/auto_gamepieces_view.dart";
import "dart:ui" as ui;

class AutoNoteSelection extends StatelessWidget {
  const AutoNoteSelection({
    super.key,
    required this.gamepieceOrder,
    required this.field,
    required this.onNoteClicked,
  });

  final List<AutoGamepieceID> gamepieceOrder;
  final ui.Image field;
  final void Function(AutoGamepieceID?) onNoteClicked;

  @override
  Widget build(final BuildContext context) => AspectRatio(
        aspectRatio: autoFieldWidth / fieldheight,
        child: LayoutBuilder(
          builder: (
            final BuildContext context,
            final BoxConstraints constraints,
          ) =>
              Listener(
            onPointerDown: (final PointerDownEvent event) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final double pixelToMeterRatio =
                  autoFieldWidth / constraints.maxWidth;
              final Offset offset = box
                  .globalToLocal(event.position)
                  .scale(pixelToMeterRatio, pixelToMeterRatio);
              final Offset? clickedNote = notesPlacements.keys.firstWhereOrNull(
                (final ui.Offset e) =>
                    inTolerance(offset.dx, e.dx, 0.3) &&
                    inTolerance(offset.dy, e.dy, 0.3),
              );
              onNoteClicked(
                clickedNote != null ? notesPlacements[clickedNote] : null,
              );
            },
            child: CustomPaint(
              painter: AutoFieldCanvas(
                fieldBackground: field,
                gamepieceOrder: gamepieceOrder,
                meterToPixelRatio: constraints.maxWidth / autoFieldWidth,
              ),
            ),
          ),
        ),
      );
}

import "dart:typed_data";
import "dart:ui" as ui;

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/semantics.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";

class AutoGamepiecesScreen extends StatelessWidget {
  const AutoGamepiecesScreen({super.key});

  @override
  Widget build(BuildContext context) => isPC(context)
      ? DashboardScaffold(
          body: const Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: AutoField(),
          ),
        )
      : Scaffold(
          appBar: AppBar(
            title: const Text("Alliance Auto"),
            centerTitle: true,
          ),
          drawer: SideNavBar(),
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
              child: const AutoField(),
              scrollDirection: isPC(context) ? Axis.horizontal : Axis.vertical,
            ),
          ),
        );
}

class AutoField extends StatefulWidget {
  const AutoField({super.key});

  @override
  State<AutoField> createState() => _AutoFieldState();
}

class _AutoFieldState extends State<AutoField> {
  LightTeam? team;
  ui.Image? field;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TeamSelectionFuture(
                    onChange: (p0) async {
                      field = await getField(false);
                      print(field);
                      setState(() {
                        team = p0;
                      });
                    },
                    controller: controller),
              ),
              Expanded(
                child: Container(),
                flex: 2,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (field != null)
            Expanded(
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: autoFieldWidth / fieldheight,
                    child: LayoutBuilder(
                      builder: (
                        final BuildContext context,
                        final BoxConstraints constraints,
                      ) =>
                          Listener(
                        onPointerDown: (event) {
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;

                          final double pixelToMeterRatio =
                              autoFieldWidth / constraints.maxWidth;
                          final Offset offset = box
                              .globalToLocal(event.position)
                              .scale(pixelToMeterRatio, pixelToMeterRatio);
                          print("${offset.dx} ${offset.dy}");
                        },
                        child: CustomPaint(
                          painter: AutoFieldCanvas(
                            fieldBackground: field!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
}

Future<ui.Image> getField(final bool isRed) async {
  final ByteData data = await rootBundle
      .load("lib/assets/frc_2024_field_${isRed ? "red" : "blue"}.png");
  final ui.Codec codec =
      await ui.instantiateImageCodec(data.buffer.asUint8List());
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}

class AutoFieldCanvas extends CustomPainter {
  AutoFieldCanvas({
    required this.fieldBackground,
  });
  final ui.Image fieldBackground;

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
  }

  @override
  bool shouldRepaint(covariant final AutoFieldCanvas oldDelegate) => true;
}

List<(AutoGamepieceID, Offset)> notesPlacements =
    <(AutoGamepieceID, ui.Offset)>[
  (AutoGamepieceID.one, const Offset(2.88, 1.22)),
  (AutoGamepieceID.two, const Offset(2.88, 2.65)),
  (AutoGamepieceID.three, const Offset(2.88, 4.04)),
  (AutoGamepieceID.four, const Offset(8.2, 0.75)),
  (AutoGamepieceID.five, const Offset(8.2, 2.375)),
  (AutoGamepieceID.six, const Offset(8.2, 4.05)),
  (AutoGamepieceID.seven, const Offset(8.2, 5.7)),
  (AutoGamepieceID.eight, const Offset(8.2, 3.32)),
];

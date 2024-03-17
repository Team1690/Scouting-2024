import "dart:typed_data";
import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/painting.dart";
import "package:flutter/rendering.dart";
import "package:flutter/semantics.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/models/fetch_functions/fetch_single_team.dart";
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
          if (team != null && field != null)
            StreamBuilder(
                stream: fetchSingleTeamData(team!.id, context),
                builder: (context, snapshot) => snapshot.mapSnapshot(
                      onWaiting: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      onError: (final Object error) => Text(error.toString()),
                      onNoData: () => const Center(
                        child: Text("No data"),
                      ),
                      onSuccess: (data) =>
                          AutoGamepiecesData(data: data, field: field!),
                    )),
        ],
      );
}

class AutoGamepiecesData extends StatefulWidget {
  const AutoGamepiecesData({required this.data, required this.field});
  final TeamData data;
  final ui.Image field;

  @override
  State<AutoGamepiecesData> createState() => _AutoGamepiecesDataState();
}

class _AutoGamepiecesDataState extends State<AutoGamepiecesData> {
  List<AutoGamepieceID> currentAuto = [];
  AutoGamepieceID? selectedNote;
  @override
  Widget build(BuildContext context) {
    final Map<List<AutoGamepieceID>, List<TechnicalMatchData>> autos = groupBy(
      widget.data.technicalMatches,
      (final TechnicalMatchData match) => match.autoGamepieces
          .map((final (AutoGamepieceID, AutoGamepieceState) autogampiece) =>
              autogampiece.$1)
          .toList(),
    );
    if (autos.isNotEmpty) {
      currentAuto = autos.entries.first.key;
    }

    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AspectRatio(
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
                    Offset? clickedNote = notesPlacements.keys.firstWhereOrNull(
                        (e) =>
                            inTolarance(offset.dx, e.dx, 0.3) &&
                            inTolarance(offset.dy, e.dy, 0.3));
                    selectedNote = clickedNote != null
                        ? notesPlacements[clickedNote]
                        : null;
                    setState(() {});
                  },
                  child: CustomPaint(
                    painter: AutoFieldCanvas(
                        fieldBackground: widget.field,
                        gamepieceOrder: currentAuto,
                        meterToPixelRatio:
                            constraints.maxWidth / autoFieldWidth),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          //TODO
                        },
                        icon: Icon(Icons.skip_previous)),
                    IconButton(
                        onPressed: () {
                          //TODO
                        },
                        icon: Icon(Icons.skip_next))
                  ],
                ),
                if (currentAuto.isNotEmpty) ...[
                  Text(
                      "avg gamepieces: ${(autos[currentAuto]!.map((e) => e.data.autoGamepieces).toList().averageOrNull ?? 0).toStringAsFixed(2)}"),
                  Text(
                      "avg points: ${(autos[currentAuto]!.map((e) => e.data.autoPoints).toList().averageOrNull ?? 0).toStringAsFixed(2)}"),
                  Text(
                      "avg misses: ${(autos[currentAuto]!.map((e) => e.data.missedAuto).toList().averageOrNull ?? 0).toStringAsFixed(2)}"),
                ],
                if (selectedNote != null) ...[
                  Text("${selectedNote?.title}"),
                ]
              ],
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
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
  AutoFieldCanvas(
      {required this.fieldBackground,
      required this.gamepieceOrder,
      required this.meterToPixelRatio});
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
      final textPainter = TextPainter(
        text: TextSpan(
            text: i.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            )),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      textPainter.paint(
          canvas,
          notesPlacements.entries
                  .firstWhereOrNull(
                      (MapEntry<ui.Offset, AutoGamepieceID> element) =>
                          element.value == gamepieceOrder[i])
                  ?.key
                  .scale(meterToPixelRatio, meterToPixelRatio) ??
              Offset(0, 0));
    }
  }

  @override
  bool shouldRepaint(covariant final AutoFieldCanvas oldDelegate) => true;
}

Map<Offset, AutoGamepieceID> notesPlacements = Map.fromEntries([
  (const Offset(2.88, 1.22), AutoGamepieceID.one),
  (const Offset(2.88, 2.65), AutoGamepieceID.two),
  (const Offset(2.88, 3.88), AutoGamepieceID.three),
  (const Offset(8.2, 0.75), AutoGamepieceID.four),
  (const Offset(8.2, 2.375), AutoGamepieceID.five),
  (const Offset(8.2, 4.05), AutoGamepieceID.six),
  (const Offset(8.2, 5.7), AutoGamepieceID.seven),
  (const Offset(8.2, 7.04), AutoGamepieceID.eight),
].map((e) => MapEntry(e.$1, e.$2)));

bool inTolarance(double val, double target, double tolerance) =>
    val <= target + tolerance && val >= target - tolerance;

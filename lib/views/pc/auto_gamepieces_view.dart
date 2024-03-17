import "dart:math";
import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
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

class DeepEqList<T> {
  const DeepEqList(this.list);

  final List<T> list;

  @override
  bool operator ==(final Object other) =>
      other is DeepEqList<T> && ListEquality<T>().equals(other.list, list);

  @override
  int get hashCode => list.hashCode;
}

class AutoGamepiecesScreen extends StatelessWidget {
  const AutoGamepiecesScreen({super.key});

  @override
  Widget build(final BuildContext context) => isPC(context)
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
  Widget build(final BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TeamSelectionFuture(
                  onChange: (final LightTeam p0) async {
                    field = await getField(false);
                    print(field);
                    setState(() {
                      team = p0;
                    });
                  },
                  controller: controller,
                ),
              ),
              Expanded(
                child: Container(),
                flex: 2,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (team != null && field != null)
            StreamBuilder(
              stream: fetchSingleTeamData(team!.id, context),
              builder: (
                final BuildContext context,
                final AsyncSnapshot<TeamData> snapshot,
              ) =>
                  snapshot.mapSnapshot(
                onWaiting: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                onError: (final Object error) => Text(error.toString()),
                onNoData: () => const Center(
                  child: Text("No data"),
                ),
                onSuccess: (final TeamData data) =>
                    AutoGamepiecesData(data: data, field: field!),
              ),
            ),
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
  int currentAutoIndex = 0;
  AutoGamepieceID? selectedNote;
  @override
  Widget build(final BuildContext context) {
    final grouped = groupBy(
      widget.data.technicalMatches,
      (final TechnicalMatchData match) => DeepEqList<AutoGamepieceID>(
        match.autoGamepieces
            .map(
              (
                final (AutoGamepieceID, AutoGamepieceState) autogampiece,
              ) =>
                  autogampiece.$1,
            )
            .toList(),
      ),
    );
    print(grouped.keys);

    final List<({List<AutoGamepieceID> auto, List<TechnicalMatchData> matches})>
        autos = grouped.entries.map(
      (
        final MapEntry<DeepEqList<AutoGamepieceID>, List<TechnicalMatchData>>
            element,
      ) {
        return (auto: element.key.list, matches: element.value);
      },
    ).toList();

    // print(autos.length);
    if (autos.isEmpty) {
      return const Text("No Data");
    }
    return Expanded(
      child: Row(
        children: <Widget>[
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
                  onPointerDown: (final PointerDownEvent event) {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;

                    final double pixelToMeterRatio =
                        autoFieldWidth / constraints.maxWidth;
                    final Offset offset = box
                        .globalToLocal(event.position)
                        .scale(pixelToMeterRatio, pixelToMeterRatio);
                    final Offset? clickedNote =
                        notesPlacements.keys.firstWhereOrNull(
                      (final ui.Offset e) =>
                          inTolarance(offset.dx, e.dx, 0.3) &&
                          inTolarance(offset.dy, e.dy, 0.3),
                    );
                    selectedNote = clickedNote != null
                        ? notesPlacements[clickedNote]
                        : null;
                    setState(() {});
                  },
                  child: CustomPaint(
                    painter: AutoFieldCanvas(
                      fieldBackground: widget.field,
                      gamepieceOrder: autos[currentAutoIndex].auto,
                      meterToPixelRatio: constraints.maxWidth / autoFieldWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentAutoIndex = max(0, currentAutoIndex - 1);
                        });
                      },
                      icon: const Icon(Icons.skip_previous),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentAutoIndex =
                              min(autos.length - 1, currentAutoIndex + 1);
                        });
                      },
                      icon: const Icon(Icons.skip_next),
                    ),
                  ],
                ),
                if (autos[currentAutoIndex].auto.isNotEmpty) ...<Widget>[
                  Text(
                    "avg gamepieces: ${(autos[currentAutoIndex].matches.map((final TechnicalMatchData e) => e.data.autoGamepieces).toList().averageOrNull ?? 0).toStringAsFixed(2)}",
                  ),
                  Text(
                    "avg points: ${(autos[currentAutoIndex].matches.map((final TechnicalMatchData e) => e.data.autoPoints).toList().averageOrNull ?? 0).toStringAsFixed(2)}",
                  ),
                  Text(
                    "avg misses: ${(autos[currentAutoIndex].matches.map((final TechnicalMatchData e) => e.data.missedAuto).toList().averageOrNull ?? 0).toStringAsFixed(2)}",
                  ),
                ],
                if (selectedNote != null) ...<Widget>[
                  Text("${selectedNote?.title}"),
                ],
              ],
            ),
            flex: 1,
          ),
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
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: i.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
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

Map<Offset, AutoGamepieceID> notesPlacements = Map.fromEntries(
  <(ui.Offset, AutoGamepieceID)>[
    (const Offset(0, fieldheight / 2), AutoGamepieceID.zero),
    (const Offset(2.88, 1.22), AutoGamepieceID.one),
    (const Offset(2.88, 2.65), AutoGamepieceID.two),
    (const Offset(2.88, 3.88), AutoGamepieceID.three),
    (const Offset(8.2, 0.75), AutoGamepieceID.four),
    (const Offset(8.2, 2.375), AutoGamepieceID.five),
    (const Offset(8.2, 4.05), AutoGamepieceID.six),
    (const Offset(8.2, 5.7), AutoGamepieceID.seven),
    (const Offset(8.2, 7.04), AutoGamepieceID.eight),
  ].map((final (ui.Offset, AutoGamepieceID) e) => MapEntry(e.$1, e.$2)),
);

bool inTolarance(
  final double val,
  final double target,
  final double tolerance,
) =>
    val <= target + tolerance && val >= target - tolerance;

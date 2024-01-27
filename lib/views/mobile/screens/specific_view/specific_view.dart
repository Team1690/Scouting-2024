import "dart:async";
import "dart:ui" as ui;
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/csv_or_url.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/matches_model.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/dropdown_line.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/mobile/firebase_submit_button.dart";
import "package:scouting_frontend/views/mobile/screens/robot_image.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/auto_path.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_vars.dart";
import "package:http/http.dart" as http;
import "package:scouting_frontend/views/mobile/submit_button.dart";
import "package:scouting_frontend/views/mobile/team_and_match_selection.dart";

class Specific extends StatefulWidget {
  @override
  State<Specific> createState() => _SpecificState();
}

class _SpecificState extends State<Specific> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController matchController = TextEditingController();
  final TextEditingController faultsController = TextEditingController();
  final FocusNode node = FocusNode();

  late final Map<int, int> defenseAmountIndexToId = <int, int>{
    -1: IdProvider.of(context).defense.nameToId["No Defense"]!,
    0: IdProvider.of(context).defense.nameToId["Half Defense"]!,
    1: IdProvider.of(context).defense.nameToId["Full Defense"]!,
  };
  ui.Image? fieldImage;
  bool didDefense = false;
  late SpecificVars vars = SpecificVars(context);
  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: node.unfocus,
        child: Scaffold(
          drawer: SideNavBar(),
          appBar: AppBar(
            actions: <Widget>[RobotImageButton(teamId: () => vars.team?.id)],
            centerTitle: true,
            title: const Text("Specific"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: FutureBuilder<List<(List<ui.Offset>, String)>>(
              future: vars.team != null
                  ? getPaths(vars.team!.id)
                  : Future<List<(List<ui.Offset>, String)>>(
                      () => <(List<ui.Offset>, String)>[],
                    ),
              builder: (
                final BuildContext context,
                final AsyncSnapshot<List<(List<ui.Offset>, String)>> snapshot,
              ) =>
                  SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        validator: (final String? value) =>
                            value != null && value.isNotEmpty
                                ? null
                                : "Please enter your name",
                        onChanged: (final String p0) {
                          vars = vars.copyWith(name: always(p0));
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          hintText: "Scouter names",
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TeamAndMatchSelection(
                        matchController: matchController,
                        teamNumberController: teamController,
                        onChange: (
                          final ScheduleMatch selectedMatch,
                          final LightTeam? selectedTeam,
                        ) {
                          setState(() {
                            vars = vars.copyWith(
                              scheduleMatch: always(selectedMatch),
                              team: always(selectedTeam),
                              autoPath: always(null),
                            );
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ToggleButtons(
                        fillColor: const Color.fromARGB(10, 244, 67, 54),
                        selectedColor: Colors.red,
                        selectedBorderColor: Colors.red,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Rematch"),
                          ),
                        ],
                        isSelected: <bool>[vars.isRematch],
                        onPressed: (final int i) {
                          setState(() {
                            vars = vars.copyWith(
                              isRematch: always(!vars.isRematch),
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: snapshot.data != null &&
                                  snapshot.data!.isNotEmpty
                              ? null
                              : MaterialStateProperty.all<Color>(Colors.grey),
                        ),
                        onPressed: () async {
                          fieldImage = await getField(true);
                          if (fieldImage != null) {
                            unawaited(
                              Navigator.push(
                                context,
                                MaterialPageRoute<AutoPath>(
                                  builder: (final BuildContext buildContext) =>
                                      AutoPath(
                                    existingPaths: snapshot.data ??
                                        <(
                                          List<ui.Offset>,
                                          String
                                        )>[], //TODO query takes time to fetch the data and the AutoPath button may be pressed before it does. maybe save auto paths and display saved ones if query is delayed due to poor connection?
                                    fieldBackground: fieldImage!,
                                    onChange: (final CsvOrUrl result) {
                                      setState(() {
                                        vars = vars.copyWith(
                                          autoPath: always(result),
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text("Create Auto Path"),
                      ),
                      if (vars.autoPath != null) ...<Widget>[
                        const SizedBox(height: 15.0),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: AspectRatio(
                            aspectRatio: autoFieldWidth / fieldheight,
                            child: LayoutBuilder(
                              builder: (
                                final BuildContext context,
                                final BoxConstraints constraints,
                              ) =>
                                  CustomPaint(
                                painter: DrawingCanvas(
                                  width: 3,
                                  fieldBackground: fieldImage!,
                                  sketch: Sketch(
                                    points: vars.autoPath.runtimeType == Csv
                                        ? (vars.autoPath as Csv)
                                            .csv
                                            .split("\n")
                                            .map(
                                              (final String e) => Offset(
                                                double.tryParse(
                                                      e.split(",").first,
                                                    ) ??
                                                    0,
                                                double.tryParse(
                                                      e.split(",").last,
                                                    ) ??
                                                    0,
                                              ),
                                            )
                                            .map(
                                              (final ui.Offset e) => e.scale(
                                                constraints.maxWidth /
                                                    autoFieldWidth,
                                                constraints.maxWidth /
                                                    autoFieldWidth,
                                              ),
                                            )
                                            .toList()
                                        : snapshot.data != null &&
                                                vars.autoPath.runtimeType == Url
                                            ? snapshot.data!
                                                .firstWhere(
                                                  (
                                                    final (
                                                      List<ui.Offset>,
                                                      String
                                                    ) element,
                                                  ) =>
                                                      element.$2 ==
                                                      (vars.autoPath as Url)
                                                          .url,
                                                )
                                                .$1
                                                .map(
                                                  (final ui.Offset e) =>
                                                      e.scale(
                                                    constraints.maxWidth /
                                                        autoFieldWidth,
                                                    constraints.maxWidth /
                                                        autoFieldWidth,
                                                  ),
                                                )
                                                .toList()
                                            : <Offset>[],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 15.0),
                      RatingDropdownLine<String>(
                        onTap: () {
                          setState(() {
                            vars = vars.copyWith(
                              driveRating: always(vars.driveRating.onNull(1)),
                            );
                          });
                        },
                        value: vars.driveRating?.toDouble(),
                        onChange: (final double p0) {
                          setState(() {
                            vars =
                                vars.copyWith(driveRating: always(p0.toInt()));
                          });
                        },
                        label: "Driving & Drivetrain",
                      ),
                      const SizedBox(height: 15.0),
                      RatingDropdownLine<String>(
                        onTap: () {
                          setState(() {
                            vars = vars.copyWith(
                              intakeRating: always(vars.intakeRating.onNull(1)),
                            );
                          });
                        },
                        value: vars.intakeRating?.toDouble(),
                        onChange: (final double p0) {
                          setState(() {
                            vars =
                                vars.copyWith(intakeRating: always(p0.toInt()));
                          });
                        },
                        label: "Intake",
                      ),
                      const SizedBox(height: 15.0),
                      RatingDropdownLine<String>(
                        onTap: () {
                          setState(() {
                            vars = vars.copyWith(
                              ampRating: always(vars.ampRating.onNull(1)),
                            );
                          });
                        },
                        value: vars.ampRating?.toDouble(),
                        onChange: (final double p0) {
                          setState(() {
                            vars = vars.copyWith(ampRating: always(p0.toInt()));
                          });
                        },
                        label: "Amp",
                      ),
                      const SizedBox(height: 15.0),
                      RatingDropdownLine<String>(
                        onTap: () {
                          setState(() {
                            vars = vars.copyWith(
                              speakerRating:
                                  always(vars.speakerRating.onNull(1)),
                            );
                          });
                        },
                        value: vars.speakerRating?.toDouble(),
                        onChange: (final double p0) {
                          setState(() {
                            vars = vars.copyWith(
                              speakerRating: always(p0.toInt()),
                            );
                          });
                        },
                        label: "Speaker",
                      ),
                      const SizedBox(height: 15.0),
                      RatingDropdownLine<String>(
                        onTap: () {
                          setState(() {
                            vars = vars.copyWith(
                              climbRating: always(vars.climbRating.onNull(1)),
                            );
                          });
                        },
                        value: vars.climbRating?.toDouble(),
                        onChange: (final double p0) {
                          setState(() {
                            vars =
                                vars.copyWith(climbRating: always(p0.toInt()));
                          });
                        },
                        label: "Climb",
                      ),
                      RatingDropdownLine<String>(
                        onTap: () {
                          setState(() {
                            vars = vars.copyWith(
                              defenseRating:
                                  always(vars.defenseRating.onNull(1)),
                            );
                            didDefense = !didDefense;
                          });
                        },
                        value: vars.defenseRating?.toDouble(),
                        onChange: (final double p0) {
                          setState(() {
                            vars = vars.copyWith(
                              defenseRating: always(p0.toInt()),
                            );
                          });
                        },
                        label: "Defense",
                      ),
                      if (didDefense) ...<Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Switcher(
                          borderRadiusGeometry: defaultBorderRadius,
                          labels: const <String>[
                            "Half Defense",
                            "Full Defense",
                          ],
                          colors: const <Color>[Colors.blue, Colors.green],
                          onChange: (final int i) {
                            setState(() {
                              vars = vars.copyWith(
                                defenseAmount:
                                    always(defenseAmountIndexToId[i]!),
                              );
                            });
                          },
                          selected: <int, int>{
                            for (final MapEntry<int, int> i
                                in defenseAmountIndexToId.entries)
                              i.value: i.key,
                          }[vars.defenseAmount]!,
                        ),
                      ],
                      RatingDropdownLine<String>(
                        onTap: () {
                          setState(() {
                            vars = vars.copyWith(
                              generalRating:
                                  always(vars.generalRating.onNull(1)),
                            );
                          });
                        },
                        value: vars.generalRating?.toDouble(),
                        onChange: (final double p0) {
                          setState(() {
                            vars = vars.copyWith(
                              generalRating: always(p0.toInt()),
                            );
                          });
                        },
                        label: "General",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Robot fault:     ",
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: ToggleButtons(
                                fillColor:
                                    const Color.fromARGB(10, 244, 67, 54),
                                focusColor:
                                    const Color.fromARGB(170, 244, 67, 54),
                                highlightColor:
                                    const Color.fromARGB(170, 244, 67, 54),
                                selectedBorderColor:
                                    const Color.fromARGB(170, 244, 67, 54),
                                selectedColor: Colors.red,
                                children: const <Widget>[
                                  Icon(
                                    Icons.cancel,
                                  ),
                                ],
                                isSelected: <bool>[vars.faultMessage != null],
                                onPressed: (final int index) {
                                  assert(index == 0);
                                  setState(() {
                                    vars = vars.copyWith(
                                      faultMessage: always(
                                        vars.faultMessage.onNull("No input"),
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: vars.faultMessage == null
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Container(),
                        secondChild: TextField(
                          controller: faultsController,
                          textDirection: TextDirection.rtl,
                          onChanged: (final String value) {
                            vars = vars.copyWith(faultMessage: always(value));
                          },
                          decoration:
                              const InputDecoration(hintText: "Robot fault"),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: submitButtons(
                          "auto_paths/${vars.scheduleMatch?.id}_${vars.team?.id}.txt",
                          () async => Uint8List.fromList(
                            (vars.autoPath as Csv).csv.codeUnits,
                          ),
                          () {
                            setState(() {
                              vars = vars.reset(context);
                              nameController.clear();
                              teamController.clear();
                              matchController.clear();
                              faultsController.clear();
                            });
                          },
                          """
                mutation A(\$defense_amount_id: Int, \$defense_rating: Int, \$driving_rating: Int, \$general_rating: Int, \$intake_rating: Int, \$is_rematch: Boolean, \$speaker_rating: Int, \$scouter_name: String, \$team_id: Int, \$path_url: String, \$climb_rating: Int, \$amp_rating: Int, \$schedule_match_id: Int, \$fault_message:String){
                  insert_specific_match(objects: {scouter_name: \$scouter_name, team_id: \$team_id, speaker_rating: \$speaker_rating, schedule_match_id: \$schedule_match_id, path_url: \$path_url, is_rematch: \$is_rematch, intake_rating: \$intake_rating, general_rating: \$general_rating, driving_rating: \$driving_rating, defense_rating: \$defense_rating, defense_amount_id: \$defense_amount_id, climb_rating: \$climb_rating, amp_rating: \$amp_rating}) {
                    affected_rows
                  }
                      ${vars.faultMessage == null ? "" : """
                  insert_faults(objects: {team_id: \$team_id, message: \$fault_message, match_type_id: \$schedule_match_id,}) {
                    affected_rows
                  }"""}
                      }
                
                          """,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  Widget submitButtons(
    final String filePath,
    final Future<Uint8List?> Function() getResult,
    final void Function() resetForm,
    final String mutation,
  ) =>
      vars.autoPath.runtimeType == Csv
          ? FireBaseSubmitButton(
              filePath: filePath,
              getResult: getResult,
              vars: vars,
              validate: () => formKey.currentState!.validate(),
              resetForm: resetForm,
              mutation: mutation,
            )
          : SubmitButton(
              getJson: () => vars.toJson(),
              validate: () => formKey.currentState!.validate(),
              resetForm: resetForm,
              mutation: mutation,
            );

  Future<ui.Image> getField(final bool isRed) async {
    final ByteData data = await rootBundle
        .load("lib/assets/frc_2024_field_${isRed ? "red" : "blue"}.png");
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

Future<List<String?>> fetchUrls(final int team) async {
  final GraphQLClient client = getClient();
  const String query = r"""
query MyQuery($team: Int) {
  specific_match(where: {team_id: {_eq: $team}}) {
    path_url
  }
}
  """;
  final QueryResult<List<String>> result = await client.query(
    QueryOptions<List<String>>(
      document: gql(query),
      variables: <String, int>{"team": team},
      parserFn: parserFn,
    ),
  );
  return result.mapQueryResult();
}

List<String> parserFn(final Map<String, dynamic> urls) =>
    (urls["specific_match"] as List<dynamic>)
        .map((final dynamic url) => url["path_url"] as String)
        .toList();

Future<List<ui.Offset>> fetchPath(final String? url) async {
  if (url == null || url.isEmpty) {
    return <ui.Offset>[];
  }
  final String csv = await http.read(Uri.parse(url));
  return csv
      .split("\n")
      .map((final String e) => e.split(","))
      .map(
        (final List<String> e) =>
            Offset(double.tryParse(e.first) ?? 0, double.tryParse(e.last) ?? 0),
      )
      .toList();
}

Future<List<(List<Offset>, String)>> getPaths(final int teamId) async {
  final List<String?> urls = await fetchUrls(teamId);
  final List<Future<List<ui.Offset>>> paths =
      urls.whereNotNull().map((final String? element) {
    final Future<List<Offset>> points = fetchPath(element);
    return points;
  }).toList();
  final List<(List<ui.Offset>, String)> result = <(List<ui.Offset>, String)>[];

  for (final List<Object?> pair in IterableZip<Object?>(
    <List<Object?>>[(await Future.wait(paths)), urls],
  )) {
    result.add((pair[0] as List<ui.Offset>, pair[1] as String));
  }
  return result;
}

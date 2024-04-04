import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/edit_pit.dart";
import "package:scouting_frontend/models/data/pit_data/pit_data.dart";
import "package:scouting_frontend/views/pc/team_info/widgets/pit/robot_has_something.dart";

class PitScoutingCard extends StatelessWidget {
  PitScoutingCard(
    this.data,
  );
  final PitData data;
  @override
  Widget build(final BuildContext context) => DashboardCard(
        title: "Pit Scouting",
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (data.faultMessages == null ||
                  data.faultMessages!.isEmpty) ...<Widget>[
                const Row(
                  children: <Widget>[
                    Spacer(
                      flex: 5,
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    Spacer(),
                    Text(
                      "No Faults",
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(
                      flex: 5,
                    ),
                  ],
                ),
              ] else ...<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Faults  ",
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Icons.warning,
                      color: Colors.yellow[700],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: data.faultMessages!
                        .map(
                          (final String a) => Text(
                            a,
                            textDirection: TextDirection.rtl,
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Divider(),
              ],
              RobotHasSomething(title: "Trap", value: data.trap),
              RobotHasSomething(title: "Harmony", value: data.harmony),
              RobotHasSomething(title: "Can Eject", value: data.canEject),
              RobotHasSomething(
                title: "Can Pass Under Stage",
                value: data.canPassUnderStage,
              ),
              RobotHasSomething(title: "Climb", value: data.climb),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Shooting Range: ${data.allRangeShooting.title}"),
                    Text(
                      "Drivetrain: ${data.driveTrainType.title}",
                    ),
                    Text(
                      "Drive motor: ${data.driveMotorType.title}",
                    ),
                    Text(
                      "Weight: ${data.weight} kg",
                    ),
                    Text(
                      "Length: ${data.length} cm",
                    ),
                    Text(
                      "Width: ${data.width} cm",
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Notes",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      data.notes,
                      softWrap: true,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              if (!isPC(context)) ...<Widget>[
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push<Scaffold>(
                      PageRouteBuilder<Scaffold>(
                        reverseTransitionDuration:
                            const Duration(milliseconds: 700),
                        transitionDuration: const Duration(milliseconds: 700),
                        pageBuilder: (
                          final BuildContext context,
                          final Animation<double> a,
                          final Animation<double> b,
                        ) =>
                            GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Scaffold(
                            body: Center(
                              child: Hero(
                                tag: "Robot Image",
                                child: CachedNetworkImage(
                                  width: double.infinity,
                                  imageUrl: data.url,
                                  placeholder: (
                                    final BuildContext context,
                                    final String url,
                                  ) =>
                                      const CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: Hero(
                      tag: "Robot Image",
                      child: CachedNetworkImage(
                        imageUrl: data.url,
                        placeholder:
                            (final BuildContext context, final String url) =>
                                const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ],
              if (!isPC(context)) ...<Widget>[
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: SizedBox(
                    width: 90,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        (await showDialog<PitData>(
                          context: context,
                          builder: ((final BuildContext dialogContext) =>
                              EditPit(
                                data,
                              )),
                        ));
                      },
                      child: const Text("Edit"),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}

import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/helpers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/team_info/models/team_info_classes.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class TeamList extends StatelessWidget {
  const TeamList();

  @override
  Widget build(final BuildContext context) => DashboardScaffold(
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: StreamBuilder<List<_Team>>(
            stream: _fetchTeamList(),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<List<_Team>> snapshot,
            ) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              int? sortedColumn;
              bool isAscending = false;
              return snapshot.data.mapNullable(
                    (final List<_Team> data) => StatefulBuilder(
                      builder: (
                        final BuildContext context,
                        final void Function(void Function()) setState,
                      ) {
                        num reverseUnless<T extends num>(
                          final bool condition,
                          final T x,
                        ) =>
                            condition ? x : -x;

                        DataColumn column(
                          final String title,
                          final num Function(_Team) f, [
                          final String? toolTip,
                        ]) =>
                            DataColumn(
                              tooltip: toolTip,
                              label: Text(title),
                              numeric: true,
                              onSort: (final int index, final __) {
                                setState(() {
                                  isAscending =
                                      sortedColumn == index && !isAscending;
                                  sortedColumn = index;
                                  data.sort(
                                    (final _Team a, final _Team b) =>
                                        reverseUnless(
                                      isAscending,
                                      f(a).compareTo(f(b)),
                                    ).toInt(),
                                  );
                                });
                              },
                            );
                        return DashboardCard(
                          title: "Team list",
                          body: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            primary: false,
                            child: SingleChildScrollView(
                              primary: false,
                              child: DataTable(
                                sortColumnIndex: sortedColumn,
                                sortAscending: isAscending,
                                columns: <DataColumn>[
                                  const DataColumn(
                                    label: Text("Team number"),
                                    numeric: true,
                                  ),
                                  column(
                                    "Auto Gamepieces",
                                    (final _Team team) => team.autoGamepieceAvg,
                                  ),
                                  column(
                                    "Tele Gamepieces",
                                    (final _Team team) => team.teleSpeakerAvg,
                                  ),
                                  column(
                                    "Gamepieces Scored",
                                    (final _Team team) => team.gamepieceAvg,
                                  ),
                                  column(
                                    "Gamepiece points",
                                    (final _Team team) =>
                                        team.gamepiecePointAvg,
                                  ),
                                  column(
                                    "Broken matches",
                                    (final _Team team) => team.brokenMatches,
                                  ),
                                ],
                                rows: <DataRow>[
                                  ...data.map(
                                    (final _Team team) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    15.0,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: team.team.color,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  team.team.number.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...<double>[
                                          team.autoGamepieceAvg,
                                          team.teleSpeakerAvg,
                                          team.gamepieceAvg,
                                          team.gamepiecePointAvg,
                                        ].map(show),
                                        DataCell(
                                          Text(
                                            team.brokenMatches.toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ) ??
                  (throw Exception("No data"));
            },
          ),
        ),
      );
}

DataCell show(final double value, [final bool isPercent = false]) => DataCell(
      Text(
        value.isNaN
            ? "No data"
            : "${value.toStringAsFixed(2)}${isPercent ? "%" : ""}",
      ),
    );

class _Team {
  const _Team({
    required this.sumPoints,
    required this.autoAmpAvg,
    required this.teleAmpAvg,
    required this.autoGamepieceAvg,
    required this.teleSpeakerAvg,
    required this.gamepieceAvg,
    required this.team,
    required this.gamepiecePointAvg,
    required this.brokenMatches,
    required this.amountOfMatches,
    required this.autoSpeakerAvg,
  });
  final double sumPoints;
  final double autoSpeakerAvg;
  final double autoAmpAvg;
  final double autoGamepieceAvg;
  final double teleSpeakerAvg;
  final double teleAmpAvg;
  final double gamepieceAvg;
  final LightTeam team;
  final double gamepiecePointAvg;
  final int brokenMatches;
  final int amountOfMatches;
}

Stream<List<_Team>> _fetchTeamList() => getClient()
    .subscribe(
      SubscriptionOptions<List<_Team>>(
        document: gql(query),
        parserFn: (final Map<String, dynamic> data) {
          final List<dynamic> teams = data["team"] as List<dynamic>;
          const int autoSpeakerPoints = 5;
          const int autoAmpPoints = 2;
          const int teleSpeakerPoints = 2;
          const int teleAmpPoints = 1;
          return teams.map<_Team>((final dynamic team) {
            final List<RobotFieldStatus> robotFieldStatuses =
                (team["technical_matches_aggregate"]["nodes"] as List<dynamic>)
                    .map(
                      (final dynamic node) => robotFieldStatusTitleToEnum(
                        node["robot_field_status"]["title"] as String,
                      ),
                    )
                    .toList();
            final dynamic avg =
                team["technical_matches_aggregate"]["aggregate"]["avg"];
            final bool nullValidator = avg["auto_amp"] == null;
            final double autoGamepieceAvg = nullValidator
                ? double.nan
                : (autoAmpPoints) + (autoSpeakerPoints) / 2;
            final double teleAmpAvg =
                nullValidator ? double.nan : avg["tele_amp"] as double;
            final double teleSpeakerAvg =
                nullValidator ? double.nan : avg["tele_speaker"] as double;
            final double autoAmpAvg =
                nullValidator ? double.nan : avg["auto_amp"] as double;
            final double autoSpeakerAvg =
                nullValidator ? double.nan : avg["auto_speaker"] as double;
            final double gamepieceAvg = nullValidator
                ? double.nan
                : teleAmpAvg + teleSpeakerAvg + autoGamepieceAvg;
            final double sumPoints = nullValidator
                ? double.nan
                : (teleSpeakerAvg * teleSpeakerPoints) +
                    (teleAmpAvg * teleAmpPoints) +
                    (autoGamepieceAvg * autoAmpPoints) +
                    (autoSpeakerAvg * autoAmpPoints);

            return _Team(
              sumPoints: sumPoints,
              autoAmpAvg: autoAmpAvg,
              autoSpeakerAvg: autoSpeakerAvg,
              amountOfMatches: (team["technical_matches_aggregate"]["nodes"]
                      as List<dynamic>)
                  .length,
              brokenMatches: robotFieldStatuses
                  .where(
                    (final RobotFieldStatus robotFieldStatus) =>
                        robotFieldStatus != RobotFieldStatus.worked,
                  )
                  .length,
              autoGamepieceAvg: autoGamepieceAvg,
              teleSpeakerAvg: teleSpeakerAvg,
              teleAmpAvg: teleAmpAvg,
              gamepieceAvg: gamepieceAvg,
              gamepiecePointAvg: autoGamepieceAvg,
              team: LightTeam.fromJson(team),
            );
          }).toList();
        },
      ),
    )
    .map(
      (final QueryResult<List<_Team>> event) => event.mapQueryResult(),
    );

const String query = """
subscription MySubscription {
  team {
    id
    name
    number
    colors_index
    technical_matches_aggregate(where: {ignored: {_eq: false}}) {
      aggregate {
        avg {
           auto_amp
      auto_amp_missed
      tele_amp
      tele_amp_missed
      auto_speaker
      auto_speaker_missed
      tele_speaker
      tele_speaker_missed
        }
      }
      nodes {
        robot_field_status {
          title
        }
      }
    }
  }
}
""";

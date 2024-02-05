import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import 'package:scouting_frontend/models/schedule_match.dart';
import "package:scouting_frontend/models/matches_provider.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/team_selection_future.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view.dart";
import "package:scouting_frontend/views/mobile/team_and_match_selection.dart";

class AddFault extends StatelessWidget {
  const AddFault({required this.onFinished});
  final void Function(QueryResult<void>) onFinished;

  @override
  Widget build(final BuildContext context) => IconButton(
        onPressed: () async {
          LightTeam? team;
          String? newMessage;
          int? scheduleMatchId;
          await (await showDialog<NewFault>(
            context: context,
            builder: (final BuildContext innerContext) => AlertDialog(
              title: const Text("Add team"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MatchSearchBox(
                    matches: MatchesProvider.of(context).matches,
                    onChange: (final ScheduleMatch p0) {
                      scheduleMatchId = p0.id;
                    },
                    typeAheadController: TextEditingController(),
                  ),
                  TeamSelectionFuture(
                    teams: TeamProvider.of(context).teams,
                    onChange: (final LightTeam newTeam) {
                      team = newTeam;
                    },
                    controller: TextEditingController(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLines: 4,
                    textDirection: TextDirection.rtl,
                    onChanged: (final String a) {
                      newMessage = a;
                    },
                    decoration: const InputDecoration(
                      hintText: "Error message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (team == null || newMessage == null) return;
                    Navigator.of(context).pop(
                      NewFault(
                        newMessage!,
                        team!,
                        scheduleMatchId,
                      ),
                    );
                  },
                  child: const Text("Submit"),
                ),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ))
              .mapNullable((final NewFault p0) async {
            showLoadingSnackBar(context);
            final QueryResult<void> result = await _addFault(
              p0.team.id,
              p0.message,
              p0.scheduleMatchId,
            );
            onFinished(result);
          });
        },
        icon: const Icon(Icons.add),
      );
}

Future<QueryResult<void>> _addFault(
  final int teamId,
  final String message,
  final int? scheduleMatchId,
) =>
    getClient().mutate(
      MutationOptions<void>(
        document: gql(_addFaultMutation),
        variables: <String, dynamic>{
          "team_id": teamId,
          "fault_message": message,
          "schedule_match_id": scheduleMatchId,
        },
      ),
    );

const String _addFaultMutation = """
mutation AddFault(\$team_id:Int,\$fault_message:String \$schedule_match_id:Int){
  insert_faults(objects: {team_id: \$team_id, message: \$fault_message, schedule_match_id: \$schedule_match_id}) {
    affected_rows
  }
}
""";

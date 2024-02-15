import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/enums/fault_status_enum.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view.dart";
import "package:scouting_frontend/views/mobile/team_and_match_selection.dart";

class AddFault extends StatelessWidget {
  const AddFault({required this.onFinished});
  final void Function(QueryResult<void>) onFinished;

  @override
  Widget build(final BuildContext context) => IconButton(
        onPressed: () async {
          bool isRematch = false;
          const FaultStatus faultStatusEnum = FaultStatus.unknown;
          int? teamId;
          String? newMessage;
          int? scheduleMatchId;
          final TextEditingController matchTextController =
              TextEditingController();
          final TextEditingController teamController = TextEditingController();
          await (await showDialog<NewFault>(
            context: context,
            builder: (final BuildContext innerContext) => StatefulBuilder(
              builder: (final BuildContext context, final setState) =>
                  AlertDialog(
                title: const Text("Add team"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TeamAndMatchSelection(
                      onChange: (
                        final ScheduleMatch scheduleMatch,
                        final LightTeam? team,
                      ) {
                        scheduleMatchId = scheduleMatch.id;
                        teamId = team?.id;
                      },
                      teamNumberController: teamController,
                      matchController: matchTextController,
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
                      isSelected: <bool>[isRematch],
                      onPressed: (final _) {
                        setState(() {
                          isRematch = !isRematch;
                        });
                      },
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
                      if (teamId == null || newMessage == null) return;
                      Navigator.of(context).pop(
                        NewFault(
                          faultStatusEnum,
                          newMessage!,
                          teamId!,
                          scheduleMatchId!,
                          isRematch,
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
            ),
          ))
              .mapNullable((final NewFault newFault) async {
            showLoadingSnackBar(context);
            final QueryResult<void> result = await _addFault(
              context,
              newFault.faultStatusEnum,
              newFault.teamId,
              newFault.message,
              newFault.scheduleMatchId,
              newFault.isRematch,
            );
            onFinished(result);
          });
        },
        icon: const Icon(Icons.add),
      );
}

Future<QueryResult<void>> _addFault(
  final BuildContext context,
  final FaultStatus faultStatusEnum,
  final int teamId,
  final String message,
  final int scheduleMatchId,
  final bool isRematch,
) =>
    getClient().mutate(
      MutationOptions<void>(
        document: gql(_addFaultMutation),
        variables: <String, dynamic>{
          "is_rematch": isRematch,
          "fault_status_id": IdProvider.of(context)
              .faultStatus
              .nameToId[faultStatusEnum.title],
          "team_id": teamId,
          "fault_message": message,
          "schedule_match_id": scheduleMatchId,
        },
      ),
    );

const String _addFaultMutation = """
mutation AddFault(\$team_id:Int,\$fault_message:String \$schedule_match_id:Int  \$fault_status_id: Int \$is_rematch: Boolean!){
  insert_faults(objects: {team_id: \$team_id, message: \$fault_message, schedule_match_id: \$schedule_match_id fault_status_id: \$fault_status_id is_rematch: \$is_rematch}) {
    affected_rows
  }
}
""";

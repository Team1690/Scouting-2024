import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/enums/fault_status_enum.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class ChangeFaultStatus extends StatelessWidget {
  const ChangeFaultStatus({required this.faultId, required this.onFinished});
  final int faultId;
  final void Function(QueryResult<void>) onFinished;
  @override
  Widget build(final BuildContext context) => IconButton(
        onPressed: () async {
          FaultStatus? statusState;
          final FaultStatus? faultStatus = (await showDialog<FaultStatus>(
            context: context,
            builder: (final BuildContext context) {
              final Map<int, FaultStatus?> indexToFaultStatus =
                  <int, FaultStatus?>{
                -1: null,
                0: FaultStatus.noProgress,
                1: FaultStatus.inProgress,
                2: FaultStatus.fixed,
              };
              return StatefulBuilder(
                builder: (
                  final BuildContext context,
                  final void Function(
                    void Function(),
                  ) alertDialogSetState,
                ) =>
                    AlertDialog(
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        if (statusState != null) {
                          Navigator.of(context).pop(statusState);
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                  title: const Text(
                    "Change fault status",
                  ),
                  content: Switcher(
                    borderRadiusGeometry: defaultBorderRadius,
                    selected: <FaultStatus?, int>{
                      for (final MapEntry<int, FaultStatus?> entry
                          in indexToFaultStatus.entries)
                        entry.value: entry.key,
                    }[statusState]!,
                    onChange: (final int index) {
                      alertDialogSetState(() {
                        statusState = indexToFaultStatus[index];
                      });
                    },
                    colors: FaultStatus.values
                        .where(
                          (final FaultStatus e) => e != FaultStatus.unknown,
                        )
                        .map((final FaultStatus e) => e.color)
                        .toList(),
                    labels: FaultStatus.values
                        .where(
                          (final FaultStatus e) => e != FaultStatus.unknown,
                        )
                        .map((final FaultStatus e) => e.title)
                        .toList(),
                  ),
                ),
              );
            },
          ));

          if (faultStatus != null) {
            showLoadingSnackBar(context);
            final QueryResult<void> result = await updateFaultStatus(
              faultId,
              faultStatusTitleToEnum(faultStatus.title),
              context,
            );
            onFinished(result);
          }
        },
        icon: const Icon(Icons.build),
      );
}

Future<QueryResult<void>> updateFaultStatus(
  final int id,
  final FaultStatus faultStatus,
  final BuildContext context,
) async =>
    getClient().mutate(
      MutationOptions<void>(
        document: gql(_updateFaultStatusMutation),
        variables: <String, dynamic>{
          "id": id,
          "fault_status_id":
              IdProvider.of(context).faultStatus.nameToId[faultStatus.title],
        },
      ),
    );

const String _updateFaultStatusMutation = r"""
mutation UpdateFaultStatus($id: Int!, $fault_status_id: Int!) {
  update_faults_by_pk(pk_columns: {id: $id}, _set: {fault_status_id: $fault_status_id}) {
    id
  }
}

""";

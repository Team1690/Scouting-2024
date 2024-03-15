import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/fault_entry.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/fault_view.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/change_fault_status.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/delete_fault.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/update_fault_message.dart";

class FaultTile extends StatelessWidget {
  const FaultTile(this.e);
  final (FaultEntry, int?) e;

  @override
  Widget build(final BuildContext context) => ExpansionTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            EditFault(
              onFinished: handleQueryResult(context),
              faultMessage: e.$1.faultMessage,
              faultId: e.$1.id,
            ),
            DeleteFault(
              faultId: e.$1.id,
              onFinished: handleQueryResult(context),
            ),
            ChangeFaultStatus(
              faultId: e.$1.id,
              onFinished: handleQueryResult(context),
            ),
          ],
        ),
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(
                "${e.$1.team.number} ${e.$1.team.name} ${e.$2 != null && e.$2! > 0 ? " - ${e.$2}" : ""}",
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "Status: ${e.$1.faultStatus.title}",
                style: TextStyle(color: e.$1.faultStatus.color),
              ),
            ),
          ],
        ),
        children: <Widget>[
          ListTile(
            title: Text(
              "match: ${e.$1.matchIdentifier.type.title} ${e.$1.matchIdentifier.number} ${e.$1.matchIdentifier.isRematch ? "R" : ""}",
            ),
            subtitle: Text(
              e.$1.faultMessage,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
}

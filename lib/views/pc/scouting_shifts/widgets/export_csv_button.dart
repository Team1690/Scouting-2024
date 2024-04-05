import "package:file_saver/file_saver.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/utils/byte_utils.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/functions/shifts_to_csv.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/scouting_shift.dart";

class ExportCSVButton extends StatelessWidget {
  const ExportCSVButton({
    super.key,
    required this.shifts,
  });

  final List<List<ScoutingShift>> shifts;
  @override
  Widget build(final BuildContext context) => IconButton(
        onPressed: () async {
          if (shifts.isNotEmpty) {
            await FileSaver.instance.saveFile(
              name: "Shifts",
              ext: ".csv",
              mimeType: MimeType.csv,
              bytes: shiftsToCSV(shifts).toUint8List(),
            );
          }
        },
        icon: const Icon(Icons.save),
      );
}

import "package:file_saver/file_saver.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/utils/byte_utils.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/functions/calc_shifts.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/functions/shifts_to_csv.dart";

class ExportCSVButton extends StatelessWidget {
  const ExportCSVButton({
    super.key,
    required this.scouters,
  });

  final List<String> scouters;
  @override
  Widget build(final BuildContext context) => IconButton(
        onPressed: () async {
          if (scouters.isNotEmpty) {
            await FileSaver.instance.saveFile(
              name: "Shifts",
              ext: ".csv",
              mimeType: MimeType.csv,
              bytes: shiftsToCSV(calcScoutingShifts(context, scouters))
                  .toUint8List(),
            );
          }
        },
        icon: const Icon(Icons.save),
      );
}

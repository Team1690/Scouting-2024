import "package:scouting_frontend/models/data/technical_data.dart";
import "package:scouting_frontend/models/enums/autonomous_options_enum.dart";
import "package:scouting_frontend/models/match_identifier.dart";

class AutoData {
  const AutoData({required this.avgData, required this.autos});
  final TechnicalData<double> avgData;
  final List<(MatchIdentifier, AutonomousOptions)> autos;
}

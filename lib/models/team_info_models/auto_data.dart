import "package:scouting_frontend/models/data/technical_data.dart";
import "package:scouting_frontend/models/enums/autonomous_options_enum.dart";
import "package:scouting_frontend/models/match_identifier.dart";

class AutoData {
  AutoData({
    required this.avgData,
    required this.minData,
    required this.maxData,
    required this.autos,
  });

  final TechnicalData<double> avgData;
  final TechnicalData<int> minData;
  final TechnicalData<int> maxData;
  final List<(MatchIdentifier, AutonomousOptions)> autos;
}

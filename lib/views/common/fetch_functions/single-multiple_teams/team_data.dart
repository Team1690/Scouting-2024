import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/common/fetch_functions/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_match_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/specific_summary_data.dart";
import "package:scouting_frontend/views/common/fetch_functions/technical_match_data.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view.dart";
import "package:scouting_frontend/views/common/fetch_functions/pit_data/pit_data.dart";

class TeamData {
  TeamData({
    required this.technicalMatches,
    required this.pitData,
    required this.lightTeam,
    required this.faultEntrys,
    required this.specificMatches,
    required this.aggregateData,
    required this.summaryData,
  });
  final List<TechnicalMatchData> technicalMatches;
  final List<SpecificMatchData> specificMatches;
  final List<FaultEntry> faultEntrys;
  final AggregateData aggregateData;
  final PitData pitData;
  final SpecificSummaryData summaryData;
  final LightTeam lightTeam;
}

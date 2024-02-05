import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/models/team_data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/team_data/specific_match_data.dart";
import "package:scouting_frontend/models/team_data/specific_summary_data.dart";
import "package:scouting_frontend/models/team_data/technical_match_data.dart";
import "package:scouting_frontend/models/team_data/pit_data/pit_data.dart";
import "package:scouting_frontend/views/mobile/screens/fault_entry.dart";

class TeamData {
  TeamData({
    required this.technicalMatches,
    required this.pitData,
    required this.lightTeam,
    required this.faultEntrys,
    required this.specificMatches,
    required this.aggregateData,
    required this.summaryData,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
    required this.thirdPicklistIndex,
  });
  final List<TechnicalMatchData> technicalMatches;
  final List<SpecificMatchData> specificMatches;
  final List<FaultEntry> faultEntrys;
  final AggregateData aggregateData;
  final PitData? pitData;
  final SpecificSummaryData? summaryData;
  final LightTeam lightTeam;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
  final int thirdPicklistIndex;
}

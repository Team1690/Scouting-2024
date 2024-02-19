import "package:scouting_frontend/models/team_data/all_team_data.dart";
import "package:scouting_frontend/models/team_data/technical_data.dart";

enum AggregateType {
  median("Median"),
  max("Max"),
  min("Min");

  const AggregateType(this.title);
  final String title;
}

extension AggregateTypeExtension on AggregateType {
  TechnicalData<num> data(final AllTeamData team) {
    switch (this) {
      case AggregateType.median:
        return team.aggregateData.medianData;
      case AggregateType.max:
        return team.aggregateData.maxData;
      case AggregateType.min:
        return team.aggregateData.minData;
    }
  }
}

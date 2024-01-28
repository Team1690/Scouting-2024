import "package:scouting_frontend/models/team_model.dart";

class QuickData {
  QuickData({
    //TODO add season specific variables
    required this.amoutOfMatches,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
    required this.avgAutoAmp,
    required this.avgAutoMissedAmp,
    required this.avgAutoMissedSpeaker,
    required this.avgAutoSpeaker,
    required this.avgGamePiecesFullDefense,
    required this.avgGamePiecesHalfDefense,
    required this.avgGamePiecesNoDefense,
    required this.avgGamepiecePoints,
    required this.avgGamepieces,
    required this.avgTeleAmp,
    required this.avgTeleMissedAmp,
    required this.avgTeleMissedSpeaker,
    required this.avgTeleSpeaker,
    required this.avgTrap,
    required this.matchesClimbed,
    required this.matchesHarmonized,
  });
  final int amoutOfMatches;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
  final double avgGamepieces;
  final double avgGamepiecePoints;
  final double avgAutoSpeaker;
  final double avgAutoAmp;
  final double avgAutoMissedSpeaker;
  final double avgAutoMissedAmp;
  final double avgTeleSpeaker;
  final double avgTeleAmp;
  final double avgTeleMissedSpeaker;
  final double avgTeleMissedAmp;
  final double avgGamePiecesNoDefense;
  final double avgGamePiecesHalfDefense;
  final double avgGamePiecesFullDefense;
  final double avgTrap;
  final int matchesClimbed;
  final int matchesHarmonized;
}

class AutoByPosData {
  AutoByPosData({
    required this.amoutOfMatches,
  });
  final int amoutOfMatches;
}

class AutoData {
  //TODO rename these to season specific names
  AutoData({
    required this.slot3Data,
    required this.slot2Data,
    required this.slot1Data,
  });
  final AutoByPosData slot1Data;
  final AutoByPosData slot2Data;
  final AutoByPosData slot3Data;
}

class SpecificData {
  const SpecificData(this.msg);
  final List<SpecificMatch> msg;
}

class SpecificMatch {
  const SpecificMatch({
    required this.isRematch,
    required this.matchNumber,
    required this.matchTypeId,
    required this.scouterNames,
    required this.drivetrainAndDriving,
    required this.intake,
    required this.placement,
    required this.generalNotes,
    required this.defense,
  });
  final int matchNumber;
  final int matchTypeId;
  final String scouterNames;
  final bool isRematch;

  final String? drivetrainAndDriving;
  final String? intake;
  final String? placement;
  final String? defense;
  final String? generalNotes;

  bool isNull(final String val) {
    switch (val) {
      case "Drivetrain And Driving":
        return drivetrainAndDriving == null;
      case "Intake":
        return intake == null;
      case "Placement":
        return placement == null;
      case "Defense":
        return defense == null;
      case "General Notes":
        return generalNotes == null;
      case "All":
      default:
        return (drivetrainAndDriving == null &&
                intake == null &&
                placement == null &&
                defense == null &&
                generalNotes == null)
            ? true
            : false;
    }
  }
}

class LineChartData {
  LineChartData({
    required this.points,
    required this.title,
    required this.gameNumbers,
    required this.robotMatchStatuses,
    required this.defenseAmounts,
  });
  final List<List<int>> points;
  final List<List<RobotMatchStatus>> robotMatchStatuses;
  final List<List<DefenseAmount>> defenseAmounts;
  final List<MatchIdentifier> gameNumbers;
  final String title;
}

enum RobotMatchStatus { worked, didntComeToField, didntWorkOnField }

enum DefenseAmount { noDefense, halfDefense, fullDefense }

class MatchIdentifier {
  const MatchIdentifier({
    required this.number,
    required this.type,
    required this.isRematch,
  });
  final String type;
  final int number;
  final bool isRematch;

  @override
  bool operator ==(final Object other) =>
      other is MatchIdentifier &&
      other.type == type &&
      other.number == number &&
      other.isRematch == isRematch;

  @override
  int get hashCode => Object.hash(type, number, isRematch);

  @override
  String toString() => "${isRematch ? "R" : ""}${shortenType(type)}$number";

  static String shortenType(final String matchType) {
    switch (matchType) {
      case "Pre scouting":
        return "pre";
      case "Practice":
        return "pra";
      case "Quals":
        return "";
      case "Finals":
        return "f";
      case "Semi finals":
        return "sf";
      case "Quarter finals":
        return "qf";
      case "Round robin":
        return "rb";
      case "Einstein finals":
        return "ef";
      case "Double elims":
        return "de";
    }
    throw Exception("Not a supported match type");
  }
}

class PitData {
  PitData({
    required this.driveTrainType,
    required this.driveMotorAmount,
    required this.driveMotorType,
    required this.driveWheelType,
    required this.gearboxPurchased,
    required this.notes,
    required this.hasShifer,
    required this.url,
    required this.faultMessages,
    required this.weight,
    required this.team,
  });
  //TODO add season specific variables
  final String driveTrainType;
  final int driveMotorAmount;
  final String driveWheelType;
  final bool? hasShifer;
  final bool? gearboxPurchased;
  final String driveMotorType;
  final String notes;
  final int weight;
  final String url;
  final List<String>? faultMessages;
  final LightTeam team;
}

class Team {
  Team({
    required this.team,
    required this.specificData,
    required this.pitViewData,
    required this.quickData,
    required this.autoData,
  });
  //TODO add season specific charts and data
  final LightTeam team;
  final SpecificData specificData;
  final PitData? pitViewData;
  final QuickData quickData;
  final AutoData autoData;
}

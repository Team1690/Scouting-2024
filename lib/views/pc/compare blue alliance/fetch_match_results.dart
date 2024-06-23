import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/blue_alliance_match_data.dart";

Map<String, String> headers = <String, String>{
  "X-TBA-Auth-Key":
      "tzBu6k8gHLajGvKeMNsuWEoGaqYHWmDwaKmKreYAsw0fjScxYbDKZWGvLOTPwmRX",
};
Future<List<BlueAllianceMatchData>?> getWebsiteData(
  final String event,
) async {
  final Uri url =
      Uri.parse("https://www.thebluealliance.com/api/v3/event/$event/matches");
  final http.Response response = await http.get(url, headers: headers);
  final List<BlueAllianceMatchData> matchesData =
      (jsonDecode(response.body) as List<dynamic>).map((final dynamic element) {
    final dynamic scoreBreakdown = element["score_breakdown"] as dynamic;
    final int matchNumber = element["match_number"] as int;
    final int blueNotesAutoSpeaker =
        scoreBreakdown["blue"]["autoSpeakerNoteCount"] as int;
    final int redNotesAutoSpeaker =
        scoreBreakdown["red"]["autoSpeakerNoteCount"] as int;
    final int blueNotesTeleAmp =
        scoreBreakdown["blue"]["teleopAmpNoteCount"] as int;
    final int redNotesTeleAmp =
        scoreBreakdown["red"]["teleopAmpNoteCount"] as int;
    final int blueNotesTeleAmplifiedSpeaker =
        scoreBreakdown["blue"]["teleopSpeakerNoteAmplifiedCount"] as int;
    final int blueNotesTeleSpeaker =
        scoreBreakdown["blue"]["teleopSpeakerNoteCount"] as int;
    final int totalBlueNotesTeleSpeaker =
        blueNotesTeleSpeaker + blueNotesTeleAmplifiedSpeaker;
    final int redNotesTeleAmplifiedSpeaker =
        scoreBreakdown["red"]["teleopSpeakerNoteAmplifiedCount"] as int;
    final int redNotesTeleSpeaker =
        scoreBreakdown["red"]["teleopSpeakerNoteCount"] as int;
    final int totalRedNotesTeleSpeaker =
        redNotesTeleSpeaker + redNotesTeleAmplifiedSpeaker;
    final int blueTeleopSpeakerNoteAmplifiedPoints =
        scoreBreakdown["blue"]["teleopSpeakerNoteAmplifiedPoints"] as int;
    final int redTeleopSpeakerNoteAmplifiedPoints =
        scoreBreakdown["red"]["teleopSpeakerNoteAmplifiedPoints"] as int;
    final int blueScore = element["alliances"]["blue"]["score"] as int;
    final int redScore = element["alliances"]["red"]["score"] as int;
    final int blueScoreWithoutAmplified = blueScore -
        blueTeleopSpeakerNoteAmplifiedPoints +
        blueNotesTeleAmplifiedSpeaker * 2;
    final int redScoreWithoutAmplified = redScore -
        redTeleopSpeakerNoteAmplifiedPoints +
        redNotesTeleAmplifiedSpeaker * 2;

    return BlueAllianceMatchData(
      matchNumber: matchNumber,
      blueScore: blueScoreWithoutAmplified,
      redScore: redScoreWithoutAmplified,
      blueNotesAutoSpeaker: blueNotesAutoSpeaker,
      redNotesAutoSpeaker: redNotesAutoSpeaker,
      blueNotesTeleAmp: blueNotesTeleAmp,
      redNotesTeleAmp: redNotesTeleAmp,
      totalBlueNotesTeleSpeaker: totalBlueNotesTeleSpeaker,
      totalRedNotesTeleSpeaker: totalRedNotesTeleSpeaker,
    );
  }).toList();
  return matchesData;
}

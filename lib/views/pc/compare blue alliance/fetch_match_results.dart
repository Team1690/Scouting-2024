import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/blue_alliance_match_data.dart";

Map<String, String> headers = <String, String>{
  "X-TBA-Auth-Key":
      "tzBu6k8gHLajGvKeMNsuWEoGaqYHWmDwaKmKreYAsw0fjScxYbDKZWGvLOTPwmRX",
};
Future<List<BlueAllianceMatchData>?> getWebsiteData(final String? event) async {
  final Uri url =
      Uri.parse("https://www.thebluealliance.com/api/v3/event/$event/matches");
  final http.Response response = await http.get(url, headers: headers);
  final List<BlueAllianceMatchData> matchesData =
      (jsonDecode(response.body) as List<dynamic>).map((final dynamic element) {
    final dynamic alliances = element["alliances"];
    final dynamic scoreBreakdown = element["score_breakdown"];
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
    final int blueNotesTeleSpeakerWithoutAmplified =
        scoreBreakdown["blue"]["teleopSpeakerNoteCount"] as int;
    final int blueNotesTeleSpeaker =
        blueNotesTeleSpeakerWithoutAmplified + blueNotesTeleAmplifiedSpeaker;
    final int redNotesTeleAmplifiedSpeaker =
        scoreBreakdown["red"]["teleopSpeakerNoteAmplifiedCount"] as int;
    final int redNotesTeleSpeakerWithoutAmplified =
        scoreBreakdown["red"]["teleopSpeakerNoteCount"] as int;
    final int redNotesTeleSpeaker =
        redNotesTeleSpeakerWithoutAmplified + redNotesTeleAmplifiedSpeaker;
    final int blueTeleopSpeakerNoteAmplifiedPoints =
        scoreBreakdown["blue"]["teleopSpeakerNoteAmplifiedPoints"] as int;
    final int redTeleopSpeakerNoteAmplifiedPoints =
        scoreBreakdown["red"]["teleopSpeakerNoteAmplifiedPoints"] as int;
    final int blueScore = alliances["blue"]["score"] as int;
    final int redScore = alliances["red"]["score"] as int;
    final int blueScoreWithoutAmplified = blueScore -
        blueTeleopSpeakerNoteAmplifiedPoints +
        blueNotesTeleAmplifiedSpeaker * 2;
    final int redScoreWithoutAmplified = redScore -
        redTeleopSpeakerNoteAmplifiedPoints +
        redNotesTeleAmplifiedSpeaker * 2;
    final int blueNotesSpeaker = blueNotesTeleSpeaker + blueNotesAutoSpeaker;
    final int redNotesSpeaker = redNotesTeleSpeaker + redNotesAutoSpeaker;

    return BlueAllianceMatchData(
      matchNumber: matchNumber,
      blueScore: blueScoreWithoutAmplified,
      redScore: redScoreWithoutAmplified,
      blueNotesAutoSpeaker: blueNotesAutoSpeaker,
      redNotesAutoSpeaker: redNotesAutoSpeaker,
      blueNotesTeleAmp: blueNotesTeleAmp,
      redNotesTeleAmp: redNotesTeleAmp,
      blueNotesTeleSpeaker: blueNotesTeleSpeaker,
      redNotesTeleSpeaker: redNotesTeleSpeaker,
      blueNotesSpeaker: blueNotesSpeaker,
      redNotesSpeaker: redNotesSpeaker,
    );
  }).toList();
  return matchesData;
}
import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:scouting_frontend/views/pc/compare%20blue%20alliance/blue_alliance_match_data.dart";

Map<String, String> headers = <String, String>{
  "X-TBA-Auth-Key":
      "tzBu6k8gHLajGvKeMNsuWEoGaqYHWmDwaKmKreYAsw0fjScxYbDKZWGvLOTPwmRX",
};
Future<List<BlueAllianceMatchData>?> getWebsiteData(final String event) async {
  final Uri url =
      Uri.parse("https://www.thebluealliance.com/api/v3/event/$event/matches");
  final http.Response response = await http.get(url, headers: headers);
  final List<BlueAllianceMatchData> matchesData =
      (jsonDecode(response.body) as List<dynamic>).map((final dynamic element) {
    final dynamic alliances = element["alliances"];
    final int blueNotesAutoSpeaker =
        alliances["blue"]["autoSpeakerNoteCount"] as int;
    final int redNotesAutoSpeaker =
        alliances["red"]["autoSpeakerNoteCount"] as int;
    final int blueNotesTeleAmp = alliances["blue"]["teleopAmpNoteCount"] as int;
    final int redNotesTeleAmp = alliances["red"]["teleopAmpNoteCount"] as int;
    final int blueNotesTeleAmplifiedSpeaker =
        alliances["blue"]["teleopSpeakerNoteAmplifiedCount"] as int;
    final int blueNotesTeleSpeaker =
        alliances["blue"]["teleopSpeakerNoteCount"] as int;
    final int totalBlueNotesTeleSpeaker =
        blueNotesTeleSpeaker + blueNotesTeleAmplifiedSpeaker;
    final int redNotesTeleAmplifiedSpeaker =
        alliances["red"]["teleopSpeakerNoteAmplifiedCount"] as int;
    final int redNotesTeleSpeaker =
        alliances["red"]["teleopSpeakerNoteCount"] as int;
    final int totalRedNotesTeleSpeaker =
        redNotesTeleSpeaker + redNotesTeleAmplifiedSpeaker;
    final int blueTeleopSpeakerNoteAmplifiedPoints =
        alliances["blue"]["teleopSpeakerNoteAmplifiedPoints"] as int;
    final int redTeleopSpeakerNoteAmplifiedPoints =
        alliances["red"]["teleopSpeakerNoteAmplifiedPoints"] as int;
    final int blueScore = alliances["blue"]["score"] as int;
    final int redScore = alliances["red"]["score"] as int;
    final int blueScoreWithoutAmplified = blueScore -
        blueTeleopSpeakerNoteAmplifiedPoints +
        blueNotesTeleAmplifiedSpeaker * 2;
    final int redScoreWithoutAmplified = redScore -
        redTeleopSpeakerNoteAmplifiedPoints +
        redNotesTeleAmplifiedSpeaker * 2;

    return BlueAllianceMatchData(
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

import "package:collection/collection.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/match_model.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/scatter/scatter.dart";

const String query = """
query Scatter {
  team {
    colors_index
    number
    id
    name
    technical_matches_aggregate(where: {ignored: {_eq: false}}) {
    aggregate {
      stddev{
			auto_amp
      auto_amp_missed
      tele_amp
      tele_amp_missed
      auto_speaker
      auto_speaker_missed
      tele_speaker
      tele_speaker_missed
      }
      avg {
			auto_amp
      auto_amp_missed
      tele_amp
      tele_amp_missed
      auto_speaker
      auto_speaker_missed
      tele_speaker
      tele_speaker_missed
    
      }
    }
  }
    technical_matches(where: {ignored: {_eq: false}}) {
   		auto_amp
      auto_amp_missed
      tele_amp
      tele_amp_missed
      auto_speaker
      auto_speaker_missed
      tele_speaker
      tele_speaker_missed
    
  }
  }
}

""";
Future<List<ScatterData>> fetchScatterData() async {
  final GraphQLClient client = getClient();

  final QueryResult<List<ScatterData>> result = await client.query(
    QueryOptions<List<ScatterData>>(
      document: gql(query),
      parserFn: (final Map<String, dynamic> data) =>
          (data["team"] as List<dynamic>)
              .map<ScatterData?>((final dynamic scatterTeam) {
                final LightTeam team = LightTeam.fromJson(scatterTeam);
                final dynamic avg = scatterTeam["technical_matches_aggregate"]
                    ["aggregate"]["avg"];
                final dynamic stddev =
                    scatterTeam["technical_matches_aggregate"]["aggregate"]
                        ["stddev"];
                final List<dynamic> matches =
                    scatterTeam["technical_matches"] as List<dynamic>;
                // error in this line is returning null put the right value that is the avrage of the gamepiece
                if (avg["avg"] == null) {
                  //if one of these is null, the team's match data doesnt exist so we return null
                  return null;
                }
                final double avgGamepiecePoints = getPoints(parseMatch(avg));
                final Iterable<double> matchesGamepiecePoints = matches
                    .map((final dynamic match) => getPoints(parseMatch(match)));
                final double yStddevGamepiecePoints = matchesGamepiecePoints
                    .map(
                      (final double matchPoints) =>
                          (matchPoints - avgGamepiecePoints).abs(),
                    )
                    .average;
                final double gamepiecesStddev = stddev["auto_speaker"] == null
                    ? 0
                    : getPieces(parseMatch(stddev));
                final double avgGamepieces = getPieces(parseMatch(avg));
                return ScatterData(
                  avgGamepiecePoints,
                  yStddevGamepiecePoints,
                  team,
                  avgGamepieces,
                  gamepiecesStddev,
                );
              })
              .whereNotNull()
              .toList(),
    ),
  );
  return result.mapQueryResult();
}

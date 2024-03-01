import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/matches_provider.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/status/status_light_team.dart";
import "package:scouting_frontend/views/pc/status/status_match.dart";
import "package:scouting_frontend/views/pc/status/status_screen.dart";
import "package:collection/collection.dart";

import "status_item.dart";

Stream<List<StatusItem<LightTeam, String>>> fetchPreScoutingStatus(
  final bool isSpecific,
) =>
    fetchBase(
      getSubscription(isSpecific, true),
      isSpecific,
      (final dynamic scoutedMatchTable) =>
          LightTeam.fromJson(scoutedMatchTable["team"]),
      (final dynamic scoutedMatchTable) =>
          scoutedMatchTable["scouter_name"] as String,
      (final __, final _) => <String>[],
    );

Stream<List<StatusItem<I, V>>> fetchBase<I, V>(
  final String subscription,
  final bool isSpecific,
  final I Function(dynamic) parseI,
  final V Function(dynamic) parseV,
  final List<V> Function(I identifier, List<V> currentValues) getMissing,
) =>
    getClient()
        .subscribe(
          SubscriptionOptions<List<StatusItem<I, V>>>(
            document: gql(subscription),
            parserFn: (final Map<String, dynamic> data) {
              final List<dynamic> matches =
                  data[isSpecific ? "specific_match" : "technical_match"]
                      as List<dynamic>;
              final Map<I, List<dynamic>> identifierToMatch =
                  matches.groupListsBy(
                parseI,
              );
              return identifierToMatch
                  .map(
                    (final I key, final List<dynamic> value) =>
                        MapEntry<I, List<V>>(
                      key,
                      value.map(parseV).toList(),
                    ),
                  )
                  .entries
                  .map<StatusItem<I, V>>(
                    (final MapEntry<I, List<V>> statusCard) => StatusItem<I, V>(
                      missingValues: getMissing(
                        statusCard.key,
                        statusCard.value,
                      ),
                      values: statusCard.value,
                      identifier: statusCard.key,
                    ),
                  )
                  .toList();
            },
          ),
        )
        .map(
          (final QueryResult<List<StatusItem<I, V>>> event) =>
              event.mapQueryResult(),
        );

Stream<List<StatusItem<MatchIdentifier, StatusMatch>>> fetchStatus(
  final bool isSpecific,
  final BuildContext context,
) =>
    fetchBase(
      getSubscription(isSpecific, false),
      isSpecific,
      (final dynamic matchTable) => MatchIdentifier(
        number: matchTable["schedule_match"]["match_number"] as int,
        type: matchTypeTitleToEnum(
          matchTable["schedule_match"]["match_type"]["title"] as String,
        ),
        isRematch: matchTable["is_rematch"] as bool,
      ),
      (final dynamic scoutedMatchTable) {
        final LightTeam team = LightTeam.fromJson(scoutedMatchTable["team"]);
        final ScheduleMatch scheduleMatch = (MatchesProvider.of(context)
            .matches
            .where(
              (final ScheduleMatch match) =>
                  match.matchIdentifier ==
                  MatchIdentifier.fromJson(scoutedMatchTable),
            )
            .toList()
            .single);
        return StatusMatch(
          scoutedTeam: StatusLightTeam(
            isSpecific
                ? 0
                : TechnicalMatchData.parse(scoutedMatchTable)
                    .data
                    .gamePiecesPoints,
            scheduleMatch.redAlliance.contains(
              team,
            )
                ? Colors.red
                : Colors.blue,
            team,
            scheduleMatch.redAlliance.contains(
              team,
            )
                ? scheduleMatch.redAlliance.indexOf(
                    team,
                  )
                : scheduleMatch.blueAlliance.indexOf(
                    team,
                  ),
          ),
          scouter: scoutedMatchTable["scouter_name"] as String,
        );
      },
      (
        final MatchIdentifier identifier,
        final List<StatusMatch> scoutedMatches,
      ) {
        final ScheduleMatch match =
            MatchesProvider.of(context).matches.firstWhere(
                  (final ScheduleMatch element) =>
                      element.matchIdentifier == identifier,
                );

        return <LightTeam>[
          ...match.redAlliance,
          ...match.blueAlliance,
        ]
            .where(
              (final LightTeam team) => !scoutedMatches
                  .map(
                    (final StatusMatch statusMatch) =>
                        statusMatch.scoutedTeam.team,
                  )
                  .contains(team),
            )
            .map(
              (final LightTeam notScoutedTeam) => StatusMatch(
                scouter: "?",
                scoutedTeam: StatusLightTeam(
                  0,
                  match.redAlliance.contains(notScoutedTeam)
                      ? Colors.red
                      : Colors.blue,
                  notScoutedTeam,
                  -1,
                ),
              ),
            )
            .toList();
      },
    );

String getSubscription(final bool isSpecific, final bool isPreScouting) => """
subscription Status {

   ${isSpecific ? "specific_match" : "technical_match"}  (order_by: {schedule_match: {match_type: {order: asc}, match_number: asc}, is_rematch: asc},
   where: {schedule_match: {match_type: {title: {${isPreScouting ? "_eq" : "_neq"}: "Pre scouting"}}}}) {
    team {
      colors_index
      id
      number
      name
    }
      is_rematch
      schedule_match {
        match_type {
          title
        }
        match_number
subscription FetchStatus {
  schedule_matches {
    specific_matches {
      scouter_name
      team {
        colors_index
        id
        name
        number
      }
      scouter_name
      ${isSpecific ? """




""" : r"""

climb {
    }
    technical_matches {
      auto_amp
      auto_speaker
      climb {
        title
      }
      harmony_with
      is_rematch
      scouter_name
      team {
        id
        name
        number
        colors_index
      }
      
    auto_amp
      auto_amp_missed
      auto_speaker
      auto_speaker_missed
      cilmb_id
      harmony_with


"""}
      
      trap_amount
      tele_speaker
      tele_amp
    }
  }
}

""";

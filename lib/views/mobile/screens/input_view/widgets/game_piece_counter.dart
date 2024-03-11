import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/models/input_view_vars.dart" as m;
import "package:scouting_frontend/models/enums/match_mode_enum.dart" as m;

class GamePieceCounter extends StatelessWidget {
  const GamePieceCounter({
    super.key,
    required this.amp,
    required this.ampMissed,
    required this.speaker,
    required this.speakerMissed,
    required this.onAmpChange,
    required this.onAmpMissedChange,
    required this.onSpeakerChange,
    required this.onSpeakerMissedChange,
    required this.flickerScreen,
  });

  final int amp;
  final int ampMissed;
  final int speaker;
  final int speakerMissed;

  final void Function(int amp) onAmpChange;
  final void Function(int ampMissed) onAmpMissedChange;
  final void Function(int speaker) onSpeakerChange;
  final void Function(int speakerMissed) onSpeakerMissedChange;
  final void Function(int newValue, int oldValue) flickerScreen;
  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Counter(
                  label: "Scored Amp",
                  icon: Icons.speaker,
                  onChange: (final int amp) {
                    flickerScreen(amp, this.amp);
                    onAmpChange(amp);
                  },
                  count: amp,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Counter(
                  label: "Scored Speaker",
                  icon: Icons.speaker,
                  onChange: (final int speaker) {
                    flickerScreen(speaker, this.speaker);
                    onSpeakerChange(speaker);
                  },
                  count: speaker,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Counter(
                  label: "Missed Amp",
                  icon: Icons.cancel,
                  onChange: (final int ampMissed) {
                    flickerScreen(ampMissed, this.ampMissed);
                    onAmpMissedChange(ampMissed);
                  },
                  count: ampMissed,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Counter(
                  label: "Missed Speaker",
                  icon: Icons.cancel,
                  onChange: (final int speakerMissed) {
                    flickerScreen(speakerMissed, this.speakerMissed);
                    onSpeakerMissedChange(speakerMissed);
                  },
                  count: speakerMissed,
                ),
              ),
            ],
          ),
        ],
      );
}

class MatchModeGamePieceCounter extends StatelessWidget {
  const MatchModeGamePieceCounter({
    super.key,
    required this.match,
    required this.onNewMatch,
    required this.matchMode,
    required this.flickerScreen,
  });
  final m.InputViewVars match;
  final m.MatchMode matchMode;
  final void Function(m.InputViewVars) onNewMatch;
  final void Function(int newValue, int oldValue) flickerScreen;

  int modeValue(final int autoValue, final int teleValue) =>
      switch (matchMode) {
        m.MatchMode.auto => autoValue,
        m.MatchMode.tele => teleValue,
        m.MatchMode.endGame => 0,
      };

  @override
  Widget build(final BuildContext context) => GamePieceCounter(
        flickerScreen: flickerScreen,
        amp: modeValue(match.autoAmp, match.teleAmp),
        ampMissed: modeValue(match.autoAmpMissed, match.teleAmpMissed),
        speaker: modeValue(match.autoSpeaker, match.teleSpeaker),
        speakerMissed:
            modeValue(match.autoSpeakerMissed, match.teleSpeakerMissed),
        onAmpChange: (final int amp) {
          onNewMatch(
            matchMode == m.MatchMode.tele
                ? match.copyWith(teleAmp: always(amp))
                : match.copyWith(autoAmp: always(amp)),
          );
        },
        onAmpMissedChange: (final int ampMissed) {
          onNewMatch(
            matchMode == m.MatchMode.tele
                ? match.copyWith(teleAmpMissed: always(ampMissed))
                : match.copyWith(autoAmpMissed: always(ampMissed)),
          );
        },
        onSpeakerChange: (final int speaker) {
          onNewMatch(
            matchMode == m.MatchMode.tele
                ? match.copyWith(teleSpeaker: always(speaker))
                : match.copyWith(autoSpeaker: always(speaker)),
          );
        },
        onSpeakerMissedChange: (final int speakerMissed) {
          onNewMatch(
            matchMode == m.MatchMode.tele
                ? match.copyWith(teleSpeakerMissed: always(speakerMissed))
                : match.copyWith(autoSpeakerMissed: always(speakerMissed)),
          );
        },
      );
}

import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/dropdown_line.dart";
import "package:scouting_frontend/views/mobile/screens/specific_view/specific_vars.dart";

class SpecificRating extends StatelessWidget {
  const SpecificRating({
    super.key,
    required this.onChanged,
    required this.vars,
  });
  final SpecificVars vars;
  final void Function(SpecificVars) onChanged;

  @override
  Widget build(final BuildContext context) {
    final Map<int, int> defenseAmountIndexToId = <int, int>{
      -1: IdProvider.of(context).defense.nameToId["No Defense"]!,
      0: IdProvider.of(context).defense.nameToId["Half Defense"]!,
      1: IdProvider.of(context).defense.nameToId["Full Defense"]!,
    };
    return Column(
      children: [
        RatingDropdownLine<String>(
          onTap: () {
            onChanged(
              vars.copyWith(
                driveRating: always(vars.driveRating.onNull(1)),
              ),
            );
          },
          value: vars.driveRating?.toDouble(),
          onChange: (final double p0) {
            onChanged(vars.copyWith(driveRating: always(p0.toInt())));
          },
          label: "Driving & Drivetrain",
        ),
        const SizedBox(height: 15.0),
        RatingDropdownLine<String>(
          onTap: () {
            onChanged(vars.copyWith(
              intakeRating: always(vars.intakeRating.onNull(1)),
            ));
          },
          value: vars.intakeRating?.toDouble(),
          onChange: (final double p0) {
            onChanged(vars.copyWith(intakeRating: always(p0.toInt())));
          },
          label: "Intake",
        ),
        const SizedBox(height: 15.0),
        RatingDropdownLine<String>(
          onTap: () {
            onChanged(
              vars.copyWith(
                ampRating: always(vars.ampRating.onNull(1)),
              ),
            );
          },
          value: vars.ampRating?.toDouble(),
          onChange: (final double p0) {
            onChanged(vars.copyWith(ampRating: always(p0.toInt())));
          },
          label: "Amp",
        ),
        const SizedBox(height: 15.0),
        RatingDropdownLine<String>(
          onTap: () {
            onChanged(vars.copyWith(
              speakerRating: always(vars.speakerRating.onNull(1)),
            ));
          },
          value: vars.speakerRating?.toDouble(),
          onChange: (final double p0) {
            onChanged(vars.copyWith(
              speakerRating: always(p0.toInt()),
            ));
          },
          label: "Speaker",
        ),
        const SizedBox(height: 15.0),
        RatingDropdownLine<String>(
          onTap: () {
            onChanged(vars.copyWith(
              climbRating: always(vars.climbRating.onNull(1)),
            ));
          },
          value: vars.climbRating?.toDouble(),
          onChange: (final double p0) {
            onChanged(vars.copyWith(climbRating: always(p0.toInt())));
          },
          label: "Climb",
        ),
        RatingDropdownLine<String>(
          onTap: () {
            onChanged(
              vars.copyWith(
                  defenseRating: always(vars.defenseRating.onNull(1)),
                  defenseAmount: always(vars.defenseRating.onNull(1) ?? 1)),
            );
          },
          value: vars.defenseRating?.toDouble(),
          onChange: (final double p0) {
            onChanged(
              vars.copyWith(
                defenseRating: always(p0.toInt()),
              ),
            );
          },
          label: "Defense",
        ),
        if (vars.defenseRating != null) ...<Widget>[
          const SizedBox(
            height: 10,
          ),
          Switcher(
            borderRadiusGeometry: defaultBorderRadius,
            labels: const <String>[
              "Half Defense",
              "Full Defense",
            ],
            colors: const <Color>[Colors.blue, Colors.green],
            onChange: (final int i) {
              onChanged(
                vars.copyWith(
                  defenseAmount: always(defenseAmountIndexToId[i]!),
                ),
              );
            },
            selected: <int, int>{
              for (final MapEntry<int, int> i in defenseAmountIndexToId.entries)
                i.value: i.key,
            }[vars.defenseAmount]!,
          ),
        ],
        RatingDropdownLine<String>(
          onTap: () {
            onChanged(
              vars.copyWith(
                generalRating: always(vars.generalRating.onNull(1)),
              ),
            );
          },
          value: vars.generalRating?.toDouble(),
          onChange: (final double p0) {
            onChanged(vars.copyWith(
              generalRating: always(p0.toInt()),
            ));
          },
          label: "General",
        ),
      ],
    );
  }
}

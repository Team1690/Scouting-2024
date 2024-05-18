import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/validated_auto_coplete.dart";

class ScouterSearchBox extends StatelessWidget {
  const ScouterSearchBox({
    super.key,
    required this.typeAheadController,
    required this.onChanged,
    required this.scouters,
  });

  final TextEditingController typeAheadController;
  final void Function(String) onChanged;
  final List<String> scouters;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        child: ValidatedAutocomplete<String>(
          validator: (final String? selectedScouter) =>
              selectedScouter != null && selectedScouter.isNotEmpty
                  ? null
                  : "Please enter your name",
          decoration: const InputDecoration(
            hintText: "Enter Scouter Name",
          ),
          onSelected: (final String suggestion) {
            typeAheadController.text = suggestion;
            onChanged(suggestion);
          },
          optionsBuilder: (final TextEditingValue textEditingValue) =>
              scouters.where(
            (final String element) => element.startsWith(textEditingValue.text),
          ),
          displayStringForOption: (final String scouter) => scouter,
        ),
      );
}

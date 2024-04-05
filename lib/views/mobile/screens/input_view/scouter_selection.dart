import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

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
        child: TypeAheadFormField<String>(
          minCharsForSuggestions: 1,
          validator: (final String? selectedScouter) =>
              selectedScouter != null && selectedScouter.isNotEmpty
                  ? null
                  : "Please enter your name",
          textFieldConfiguration: TextFieldConfiguration(
            onTap: typeAheadController.clear,
            controller: typeAheadController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
              hintText: "Scouter name",
            ),
          ),
          onSuggestionSelected: (suggestion) {
            typeAheadController.text = suggestion;
            onChanged(suggestion);
          },
          itemBuilder: (final BuildContext context, final String suggestion) =>
              ListTile(
            title: Text(
              suggestion,
            ),
          ),
          transitionBuilder: (
            final BuildContext context,
            final Widget suggestionsBox,
            final AnimationController? controller,
          ) =>
              FadeTransition(
            child: suggestionsBox,
            opacity: CurvedAnimation(
              parent: controller!,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          noItemsFoundBuilder: (final BuildContext context) => Container(
            height: 60,
            child: const Center(
              child: Text(
                "No Scouters Found",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          suggestionsCallback: (final String pattern) =>
              scouters.where((element) => element.startsWith(pattern)),
        ),
      );
}

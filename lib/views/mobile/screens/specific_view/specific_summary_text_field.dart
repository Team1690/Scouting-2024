import "package:flutter/material.dart";

class SpecificSummaryTextField extends StatelessWidget {
  const SpecificSummaryTextField({
    super.key,
    required this.onTextChanged,
    required this.isEnabled,
    required this.controller,
    required this.label,
  });
  final void Function() onTextChanged;
  final TextEditingController controller;
  final bool isEnabled;
  final String label;

  @override
  Widget build(final BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            onTapOutside: (final PointerDownEvent event) {
              onTextChanged();
            },
            controller: controller,
            enabled: isEnabled,
            style: const TextStyle(),
            cursorColor: Colors.blue,
            maxLines: null,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label,
            ),
          ),
        ),
      );
}

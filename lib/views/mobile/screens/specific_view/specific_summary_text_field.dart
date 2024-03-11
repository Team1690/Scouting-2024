import "package:flutter/material.dart";

class SpecificSummaryTextField extends StatelessWidget {
  const SpecificSummaryTextField({
    super.key,
    required this.onTextChanged,
    this.isEnabled = true,
    required this.controller,
    required this.label,
  });
  final void Function() onTextChanged;
  final TextEditingController controller;
  final bool isEnabled;
  final String label;

  @override
  Widget build(final BuildContext context) => SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onTapOutside: (final PointerDownEvent event) {
              onTextChanged();
            },
            controller: controller,
            enabled: isEnabled,
            style: const TextStyle(),
            cursorColor: Colors.blue,
            maxLines: null,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label,
            ),
          ),
        ),
      );
}

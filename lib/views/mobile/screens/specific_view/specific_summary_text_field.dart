import "package:flutter/material.dart";

class SpecificSummaryTextField extends StatelessWidget {
  const SpecificSummaryTextField({
    super.key,
    required this.onTextChanged,
    required this.isEnabled,
    required this.controller,
  });
  final void Function() onTextChanged;
  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => Expanded(
        child: TextFormField(
          onTapOutside: (final PointerDownEvent event) {
            onTextChanged();
          },
          controller: controller,
          enabled: isEnabled,
          style: const TextStyle(),
          cursorColor: Colors.blue,
          maxLines: 2,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      );
}



// SpecificSummaryTextField(
//   onChanged: () {
//     setState(() {
//       isEnabled = false;
//     });
//   },
//   isEnabled: isEnabled,
//   controller: speakerController,
// ),
// SpecificSummaryTextField(
//   onChanged: () {
//     setState(() {
//       isEnabled = false;
//     });
//   },
//   isEnabled: isEnabled,
//   controller: climbController,
// ),
// SpecificSummaryTextField(
//   onChanged: () {
//     setState(() {
//       isEnabled = false;
//     });
//   },
//   isEnabled: isEnabled,
//   controller: drivingController,
// ),
// SpecificSummaryTextField(
//   onChanged: () {
//     setState(() {
//       isEnabled = false;
//     });
//   },
//   isEnabled: isEnabled,
//   controller: intakeController,
// ),
// SpecificSummaryTextField(
//   onChanged: () {
//     setState(() {
//       isEnabled = false;
//     });
//   },
//   isEnabled: isEnabled,
//   controller: generalController,
// ),

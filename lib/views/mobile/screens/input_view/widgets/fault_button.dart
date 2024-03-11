// Old Fault Button
//
// FittedBox(
//   fit: BoxFit.fitWidth,
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: <Widget>[
//       const FittedBox(
//         fit: BoxFit.fitHeight,
//         child: Text(
//           "Robot fault:     ",
//         ),
//       ),
//       FittedBox(
//         fit: BoxFit.fitWidth,
//         child: ToggleButtons(
//           fillColor: const Color.fromARGB(10, 244, 67, 54),
//           focusColor: const Color.fromARGB(170, 244, 67, 54),
//           highlightColor:
//               const Color.fromARGB(170, 244, 67, 54),
//           selectedBorderColor:
//               const Color.fromARGB(170, 244, 67, 54),
//           selectedColor: Colors.red,
//           children: const <Widget>[
//             Icon(
//               Icons.cancel,
//             ),
//           ],
//           isSelected: <bool>[
//             vars.faultMessage != null,
//           ],
//           onPressed: (final int index) {
//             assert(index == 0);
//             setState(() {
//               vars = vars.copyWith(
//                 faultMessage: always(
//                   vars.faultMessage.onNull("No input"),
//                 ),
//               );
//             });
//           },
//         ),
//       ),
//     ],
//   ),
// ),
// const SizedBox(
//   height: 15,
// ),
// AnimatedCrossFade(
//   duration: const Duration(milliseconds: 300),
//   crossFadeState: vars.faultMessage == null
//       ? CrossFadeState.showFirst
//       : CrossFadeState.showSecond,
//   firstChild: Container(),
//   secondChild: TextField(
//     controller: faultsController,
//     textDirection: TextDirection.rtl,
//     onChanged: (final String value) {
//       setState(() {
//         vars = vars.copyWith(
//           faultMessage: always(value),
//         );
//       });
//     },
//     decoration: const InputDecoration(
//       hintText: "Robot fault",
//     ),
//   ),
// ),

import "package:flutter/material.dart";

class FaultButton extends StatefulWidget {
  const FaultButton({
    super.key,
    required this.onToggle,
    required this.onNewFaultMessage,
  });

  final Function(bool isActivated) onToggle;
  final Function(String message) onNewFaultMessage;

  @override
  State<FaultButton> createState() => _FaultButtonState();
}

class _FaultButtonState extends State<FaultButton> {
  bool isActivated = false;
  TextEditingController faultMessageController = TextEditingController();

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    "Robot fault:     ",
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: ToggleButtons(
                    fillColor: const Color.fromARGB(10, 244, 67, 54),
                    focusColor: const Color.fromARGB(170, 244, 67, 54),
                    highlightColor: const Color.fromARGB(170, 244, 67, 54),
                    selectedBorderColor: const Color.fromARGB(170, 244, 67, 54),
                    selectedColor: Colors.red,
                    children: const <Widget>[
                      Icon(
                        Icons.cancel,
                      ),
                    ],
                    isSelected: <bool>[
                      isActivated,
                    ],
                    onPressed: (final int index) {
                      assert(index == 0);
                      setState(() {
                        isActivated = !isActivated;
                      });
                      widget.onToggle(isActivated);
                    },
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            child: TextField(
              controller: faultMessageController,
              onChanged: widget.onNewFaultMessage,
            ),
            visible: isActivated,
          ),
        ],
      );
}

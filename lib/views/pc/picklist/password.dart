import "package:flutter/material.dart";

class Password extends StatelessWidget {
  Password({
    super.key,
    required this.viewMode,
  });
  final bool viewMode;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: const Text("Enter Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(),
            TextField(
              controller: controller,
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                if (controller.text == "0961") {
                  Navigator.of(context).pop(!viewMode);
                }
              },
              child: const Text("Submit", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
}

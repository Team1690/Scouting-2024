import "package:flutter/material.dart";

// ignore: must_be_immutable
class Password extends StatefulWidget {
  Password({
    super.key,
    required this.viewMode,
  });
  bool viewMode;

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController controller = TextEditingController();
  bool viewMode = false;
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
                if (controller.text == "password") {
                  setState(() {
                    viewMode = !widget.viewMode;
                  });
                  Navigator.of(context).pop(viewMode);
                }
              },
              child: const Text("Submit", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
}

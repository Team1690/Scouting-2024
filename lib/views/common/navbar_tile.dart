import "package:flutter/material.dart";

class NavbarTile extends StatelessWidget {
  const NavbarTile({
    required this.icon,
    required this.title,
    required this.widget,
  });
  final String title;
  final IconData icon;
  final Widget Function() widget;
  @override
  Widget build(final BuildContext context) => ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            letterSpacing: 1.0,
          ),
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<Widget>(
              builder: (final BuildContext context) => widget(),
            ),
          );
        },
      );
}

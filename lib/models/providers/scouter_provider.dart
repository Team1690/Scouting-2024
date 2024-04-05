import "package:flutter/material.dart";

class ScouterProvider extends InheritedWidget {
  const ScouterProvider({required super.child, required this.scouters});
  final List<String> scouters;
  @override
  bool updateShouldNotify(covariant final ScouterProvider oldWidget) =>
      scouters != oldWidget.scouters;

  static ScouterProvider of(final BuildContext context) {
    final ScouterProvider? result =
        context.dependOnInheritedWidgetOfExactType<ScouterProvider>();
    assert(result != null, "No Scouters found in context");
    return result!;
  }
}

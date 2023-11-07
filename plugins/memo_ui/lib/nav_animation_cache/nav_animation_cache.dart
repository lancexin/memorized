import 'package:flutter/widgets.dart';

class NavAnaimationCache extends InheritedWidget {
  final Animation primaryPositionAnimation;
  final Animation secondaryPositionAnimation;

  const NavAnaimationCache(
      {super.key,
      required super.child,
      required this.primaryPositionAnimation,
      required this.secondaryPositionAnimation});

  @override
  bool updateShouldNotify(NavAnaimationCache oldWidget) {
    return primaryPositionAnimation != oldWidget.primaryPositionAnimation ||
        secondaryPositionAnimation != oldWidget.secondaryPositionAnimation;
  }

  static NavAnaimationCache? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavAnaimationCache>();
  }
}

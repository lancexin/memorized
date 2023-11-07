import 'package:flutter/material.dart';

class AlertDialogPage<T> extends Page<T> {
  final WidgetBuilder builder;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool useSafeArea;
  final bool useRootNavigator;
  final Offset? anchorPoint;
  final TraversalEdgeBehavior traversalEdgeBehavior;

  const AlertDialogPage({
    required this.builder,
    this.barrierDismissible = true,
    this.barrierColor = Colors.black54,
    this.barrierLabel,
    this.useSafeArea = true,
    this.useRootNavigator = true,
    this.anchorPoint,
    this.traversalEdgeBehavior = TraversalEdgeBehavior.closedLoop,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(
        context,
        rootNavigator: useRootNavigator,
      ).context,
    );
    return DialogRoute<T>(
      context: context,
      builder: builder,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: this,
      themes: themes,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );
  }
}

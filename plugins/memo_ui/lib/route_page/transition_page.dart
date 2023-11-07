import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:memo_ui/memo_ui.dart';

class TransitionPage<T> extends Page<T> {
  const TransitionPage({
    required this.child,
    this.maintainState = true,
    this.title,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
    this.transitionDuration = const Duration(milliseconds: 500),
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;

  final String? title;

  final bool maintainState;

  final bool fullscreenDialog;

  final bool allowSnapshotting;

  final Duration transitionDuration;

  @override
  Route<T> createRoute(BuildContext context) {
    return _PageBasedPageRoute<T>(
        page: this, allowSnapshotting: allowSnapshotting);
  }
}

class _PageBasedPageRoute<T> extends PageRoute<T> with RouteTransitionMixin<T> {
  _PageBasedPageRoute({
    required TransitionPage<T> page,
    super.allowSnapshotting = true,
  }) : super(settings: page) {
    assert(opaque);
  }

  TransitionPage<T> get _page => settings as TransitionPage<T>;

  @override
  Widget buildContent(BuildContext context) => _page.child;

  @override
  String? get title => _page.title;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  Duration get transitionDuration => _page.transitionDuration;
}

mixin RouteTransitionMixin<T> on PageRoute<T> {
  @protected
  Widget buildContent(BuildContext context);

  String? get title;

  ValueNotifier<String?>? _previousTitle;

  ValueListenable<String?> get previousTitle {
    assert(
      _previousTitle != null,
      'Cannot read the previousTitle for a route that has not yet been installed',
    );
    return _previousTitle!;
  }

  @override
  void didChangePrevious(Route<dynamic>? previousRoute) {
    final String? previousTitleString =
        previousRoute is RouteTransitionMixin ? previousRoute.title : null;
    if (_previousTitle == null) {
      _previousTitle = ValueNotifier<String?>(previousTitleString);
    } else {
      _previousTitle!.value = previousTitleString;
    }
    super.didChangePrevious(previousRoute);
  }

  @override
  Color? get barrierColor => fullscreenDialog ? null : const Color(0x18000000);

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return nextRoute is RouteTransitionMixin;
  }

  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator!.userGestureInProgress;
  }

  bool get popGestureInProgress => isPopGestureInProgress(this);

  bool get popGestureEnabled => _isPopGestureEnabled(this);

  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    if (route.isFirst) {
      return false;
    }

    if (route.willHandlePopInternally) {
      return false;
    }

    if (route.hasScopedWillPopCallback) {
      return false;
    }

    if (route.animation!.status != AnimationStatus.completed) {
      return false;
    }

    if (route.secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }

    if (isPopGestureInProgress(route)) {
      return false;
    }

    return true;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget child = buildContent(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: child,
    );
  }

  static _BackGestureController<T> _startPopGesture<T>(PageRoute<T> route) {
    assert(_isPopGestureEnabled(route));

    return _BackGestureController<T>(
      navigator: route.navigator!,
      controller: route.controller!, // protected access
    );
  }

  static Widget buildPageTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final bool linearTransition = isPopGestureInProgress(route);
    if (route.fullscreenDialog) {
      return _BottomPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: linearTransition,
        child: _BottomBackGestureDetector(
          enabledCallback: () => _isPopGestureEnabled<T>(route),
          onStartPopGesture: () => _startPopGesture<T>(route),
          child: child,
        ),
      );
    } else {
      return _LeftPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: linearTransition,
        child: _LeftBackGestureDetector<T>(
          enabledCallback: () => _isPopGestureEnabled<T>(route),
          onStartPopGesture: () => _startPopGesture<T>(route),
          child: child,
        ),
      );
    }
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return buildPageTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }
}

class _LeftBackGestureDetector<T> extends StatefulWidget {
  const _LeftBackGestureDetector({
    super.key,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  });

  final Widget child;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<_BackGestureController<T>> onStartPopGesture;

  @override
  _LeftBackGestureDetectorState<T> createState() =>
      _LeftBackGestureDetectorState<T>();
}

class _LeftBackGestureDetectorState<T>
    extends State<_LeftBackGestureDetector<T>> {
  _BackGestureController<T>? _backGestureController;

  late HorizontalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
        _convertToLogical(details.primaryDelta! / context.size!.width));
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(_convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width));
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) {
      _recognizer.addPointer(event);
    }
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    double dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? MediaQuery.paddingOf(context).left
        : MediaQuery.paddingOf(context).right;
    dragAreaWidth = max(dragAreaWidth, 20.0);
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0.0,
          width: dragAreaWidth,
          top: 0.0,
          bottom: 0.0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

class _BottomBackGestureDetector<T> extends StatefulWidget {
  const _BottomBackGestureDetector({
    super.key,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  });

  final Widget child;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<_BackGestureController<T>> onStartPopGesture;

  @override
  State<_BottomBackGestureDetector<T>> createState() =>
      _BottomBackGestureDetectorState<T>();
}

class _BottomBackGestureDetectorState<T>
    extends State<_BottomBackGestureDetector<T>> {
  _BackGestureController<T>? _backGestureController;

  late MVerticalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = MVerticalDragGestureRecognizer(debugOwner: this)
      ..onStart = handleDragStart
      ..onUpdate = handleDragUpdate
      ..onEnd = handleDragEnd
      ..onCancel = handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
        _convertToLogical(details.primaryDelta! / context.size!.height));
  }

  void handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(_convertToLogical(
        details.velocity.pixelsPerSecond.dy / context.size!.height));
    _backGestureController = null;
  }

  void handleDragCancel() {
    assert(mounted);
    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) {
      _recognizer.addPointer(event);
    }
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    return Listener(
      onPointerDown: _handlePointerDown,
      behavior: HitTestBehavior.translucent,
      child: VerticalDragGestureRecognizerCache(
        verticalDragGestureRecognizer: _recognizer,
        child: widget.child,
      ),
    );
  }
}

class _BackGestureController<T> {
  _BackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  void dragEnd(double velocity) {
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    final bool animateForward;

    if (velocity.abs() >= 1.0) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller.value > 0.5;
    }

    if (animateForward) {
      final int droppedPageForwardAnimationTime = min(
        lerpDouble(800, 0, controller.value)!.floor(),
        300,
      );
      controller.animateTo(1.0,
          duration: Duration(milliseconds: droppedPageForwardAnimationTime),
          curve: animationCurve);
    } else {
      navigator.pop();

      if (controller.isAnimating) {
        final int droppedPageBackAnimationTime =
            lerpDouble(0, 800, controller.value)!.floor();
        controller.animateBack(0.0,
            duration: Duration(milliseconds: droppedPageBackAnimationTime),
            curve: animationCurve);
      }
    }

    if (controller.isAnimating) {
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (AnimationStatus status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}

final Animatable<Offset> _kRightMiddleTween = Tween<Offset>(
  begin: const Offset(1.0, 0.0),
  end: Offset.zero,
);

final Animatable<Offset> _kMiddleLeftTween = Tween<Offset>(
  begin: Offset.zero,
  end: const Offset(-1.0 / 3.0, 0.0),
);

// Offset from offscreen below to fully on screen.
final Animatable<Offset> _kBottomUpTween = Tween<Offset>(
  begin: const Offset(0.0, 1.0),
  end: Offset.zero,
);

class _LeftPageTransition extends StatelessWidget {
  _LeftPageTransition({
    super.key,
    required Animation<double> primaryRouteAnimation,
    required Animation<double> secondaryRouteAnimation,
    required this.child,
    required bool linearTransition,
  })  : _primaryPositionAnimation = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.fastEaseInToSlowEaseOut,
                    reverseCurve: Curves.fastEaseInToSlowEaseOut.flipped,
                  ))
            .drive(_kRightMiddleTween),
        _secondaryPositionAnimation = (linearTransition
                ? secondaryRouteAnimation
                : CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(_kMiddleLeftTween);

  final Animation<Offset> _primaryPositionAnimation;
  final Animation<Offset> _secondaryPositionAnimation;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    final TextDirection textDirection = Directionality.of(context);
    return NavAnaimationCache(
        primaryPositionAnimation: _primaryPositionAnimation,
        secondaryPositionAnimation: _secondaryPositionAnimation,
        child: SlideTransition(
          position: _secondaryPositionAnimation,
          textDirection: textDirection,
          transformHitTests: false,
          child: SlideTransition(
            position: _primaryPositionAnimation,
            textDirection: textDirection,
            child: child,
          ),
        ));
  }
}

class _BottomPageTransition extends StatelessWidget {
  _BottomPageTransition({
    super.key,
    required Animation<double> primaryRouteAnimation,
    required Animation<double> secondaryRouteAnimation,
    required this.child,
    required bool linearTransition,
  })  : _positionAnimation = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.fastEaseInToSlowEaseOut,
                    reverseCurve: Curves.fastEaseInToSlowEaseOut.flipped,
                  ))
            .drive(_kBottomUpTween),
        _secondaryPositionAnimation = (linearTransition
                ? secondaryRouteAnimation
                : CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(_kMiddleLeftTween);

  final Animation<Offset> _positionAnimation;
  final Animation<Offset> _secondaryPositionAnimation;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    final TextDirection textDirection = Directionality.of(context);
    return NavAnaimationCache(
        primaryPositionAnimation: _positionAnimation,
        secondaryPositionAnimation: _secondaryPositionAnimation,
        child: SlideTransition(
          position: _secondaryPositionAnimation,
          textDirection: textDirection,
          transformHitTests: false,
          child: SlideTransition(
            position: _positionAnimation,
            child: child,
          ),
        ));
  }
}

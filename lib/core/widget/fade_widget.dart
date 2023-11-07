import 'package:flutter/widgets.dart';

enum AnimationDirection {
  forward,

  reverse,
}

class FadeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final AnimationDirection direction;
  final Curve curve;

  const FadeWidget(
      {required this.child,
      this.duration = const Duration(milliseconds: 800),
      this.direction = AnimationDirection.forward,
      this.curve = Curves.easeOut,
      Key? key})
      : super(key: key);

  @override
  State<FadeWidget> createState() => _FadeWidgetState();
}

class _FadeWidgetState extends State<FadeWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;
  late bool hideWidget;

  @override
  Widget build(BuildContext context) {
    if (hideWidget) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: opacity,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, vsync: this);
    final curved = CurvedAnimation(parent: controller, curve: widget.curve);
    var begin = widget.direction == AnimationDirection.forward ? 0.0 : 1.0;
    var end = widget.direction == AnimationDirection.forward ? 1.0 : 0.0;
    opacity = Tween<double>(begin: begin, end: end).animate(curved);
    controller.forward();

    hideWidget = false;
    if (widget.direction == AnimationDirection.reverse) {
      opacity.addStatusListener(animationStatusChange);
    }
  }

  @override
  void didUpdateWidget(FadeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Widget.canUpdate(oldWidget.child, widget.child)) return;
    opacity.removeStatusListener(animationStatusChange);
    controller.duration = widget.duration;
    controller.value = 0;
    final curved = CurvedAnimation(parent: controller, curve: widget.curve);
    var begin = widget.direction == AnimationDirection.forward ? 0.0 : 1.0;
    var end = widget.direction == AnimationDirection.forward ? 1.0 : 0.0;
    opacity = Tween<double>(begin: begin, end: end).animate(curved);
    controller.forward();

    hideWidget = false;
    if (widget.direction == AnimationDirection.reverse) {
      opacity.addStatusListener(animationStatusChange);
    }
  }

  @override
  void dispose() {
    opacity.removeStatusListener(animationStatusChange);
    controller.dispose();
    super.dispose();
  }

  void animationStatusChange(AnimationStatus status) {
    setState(() {
      hideWidget = widget.direction == AnimationDirection.reverse &&
          status == AnimationStatus.completed;
    });
  }
}

library design_size;

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:collection';
import 'package:flutter/gestures.dart';

//created by lixin
class DesignSizeUtils {
  //设计稿大小
  late Size designSize;
  late MediaQueryData originData;
  late MediaQueryData data;
  double scale = 1.0;

  bool _isDesktop = false;

  factory DesignSizeUtils() => instance;
  static DesignSizeUtils get instance => _getInstance();
  static DesignSizeUtils? _instance;
  DesignSizeUtils._internal();

  //设置设计稿的大小
  void setDesignSize(Size size) {
    designSize = size;
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      _isDesktop = true;
    }
    setup();
  }

  void reset() {
    final view = PlatformDispatcher.instance.implicitView!;
    originData = MediaQueryData.fromView(view);
    designSize = originData.size;
    if (designSize.width > designSize.height && !_isDesktop) {
      designSize = designSize.flipped;
    }
    scale = 1.0;
  }

  void setup() {
    final view = PlatformDispatcher.instance.implicitView!;
    originData = MediaQueryData.fromView(view);
    if (_isDesktop && scale != 1.0) {
      data = originData.design();
      return;
    }
    //横屏
    if (view.physicalSize.width > view.physicalSize.height && !_isDesktop) {
      scale = originData.size.height / designSize.width;
    } else {
      scale = originData.size.width / designSize.width;
    }
    data = originData.design();
  }

  static DesignSizeUtils _getInstance() {
    _instance ??= DesignSizeUtils._internal();
    return _instance!;
  }
}

class DesignSizeWidget extends StatefulWidget {
  final Widget child;
  const DesignSizeWidget({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => DesignSizeWidgetState();
}

class DesignSizeWidgetState extends State<DesignSizeWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context).design();
    return MediaQuery(
      data: mediaQueryData,
      child: DesignSize(
        data: this,
        child: widget.child,
      ),
    );
  }

  void setDesignSize(Size size) {
    DesignSizeUtils.instance.setDesignSize(size);
    WidgetsBinding.instance.handleMetricsChanged();
    setState(() {});
  }

  void reset() {
    DesignSizeUtils.instance.reset();
    WidgetsBinding.instance.handleMetricsChanged();
    setState(() {});
  }
}

class DesignSize extends InheritedWidget {
  final DesignSizeWidgetState data;

  const DesignSize({Key? key, required this.data, required Widget child})
      : super(key: key, child: child);

  static DesignSizeWidgetState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DesignSize>()?.data;
  }

  static DesignSizeWidgetState of(BuildContext context) {
    final DesignSizeWidgetState? result = maybeOf(context);
    assert(result != null, 'No DesignSizeWidgetState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DesignSize oldWidget) => data != oldWidget.data;
}

class DesignSizeWidgetsFlutterBinding extends WidgetsFlutterBinding {
  final Size designSize;

  DesignSizeWidgetsFlutterBinding(this.designSize);

  static WidgetsBinding ensureInitialized(Size size) {
    DesignSizeUtils.instance.setDesignSize(size);
    DesignSizeWidgetsFlutterBinding(size);
    return WidgetsBinding.instance;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    super.createViewConfiguration();
    DesignSizeUtils.instance.setup();
    return ViewConfiguration(
      size: DesignSizeUtils.instance.data.size,
      devicePixelRatio: DesignSizeUtils.instance.data.devicePixelRatio,
    );
  }

  @override
  void initInstances() {
    super.initInstances();
    //hooks GestureBinding
    PlatformDispatcher.instance.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  void unlocked() {
    super.unlocked();
    _flushPointerEventQueue();
  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(ui.PointerDataPacket packet) {
    try {
      _pendingPointerEvents.addAll(
          PointerEventConverter.expand(packet.data, _devicePixelRatioForView));
      if (!locked) {
        _flushPointerEventQueue();
      }
    } catch (error, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'gestures library',
        context: ErrorDescription('while handling a pointer data packet'),
      ));
    }
  }

  double? _devicePixelRatioForView(int viewId) {
    if (viewId == 0) {
      return DesignSizeUtils.instance.data.devicePixelRatio;
    }
    return platformDispatcher.view(id: viewId)?.devicePixelRatio;
  }

  @override
  void cancelPointer(int pointer) {
    if (_pendingPointerEvents.isEmpty && !locked) {
      scheduleMicrotask(_flushPointerEventQueue);
    }
    _pendingPointerEvents.addFirst(PointerCancelEvent(pointer: pointer));
  }

  void _flushPointerEventQueue() {
    assert(!locked);

    while (_pendingPointerEvents.isNotEmpty) {
      handlePointerEvent(_pendingPointerEvents.removeFirst());
    }
  }

  @override
  Widget wrapWithDefaultView(Widget rootWidget) {
    final view = platformDispatcher.implicitView!;
    return View(view: view, child: DesignSizeWidget(child: rootWidget));
  }
}

extension MediaQueryDataExt on MediaQueryData {
  MediaQueryData design() {
    final scale = DesignSizeUtils.instance.scale;
    return copyWith(
      size: size / scale,
      devicePixelRatio: devicePixelRatio * scale,
      viewInsets: viewInsets / scale,
      viewPadding: viewPadding / scale,
      padding: padding / scale,
    );
  }
}

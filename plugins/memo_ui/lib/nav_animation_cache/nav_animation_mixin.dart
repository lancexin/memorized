import 'package:flutter/widgets.dart';
import 'nav_animation_cache.dart';

mixin NavAnamationMixin {
  BuildContext get context;
  Animation? _primaryPositionAnimation;
  Animation? get primaryPositionAnimation => _primaryPositionAnimation;
  Animation? _secondaryPositionAnimation;
  Animation? get secondaryPositionAnimation => _secondaryPositionAnimation;
  AnimationStatus? _navAnimationStatus;
  AnimationStatus? get navAnimationStatus => _navAnimationStatus;

  void initState() {
    PaintingBinding.instance.addPostFrameCallback(_addPostFrameCallback);
  }

  void _addPostFrameCallback(Duration timeStamp) {
    _primaryPositionAnimation =
        NavAnaimationCache.maybeOf(context)?.primaryPositionAnimation;
    _primaryPositionAnimation?.addStatusListener(_animationStatusListener);
  }

  void removeStatusListener() {
    _primaryPositionAnimation?.removeStatusListener(_animationStatusListener);
    _primaryPositionAnimation = null;
  }

  void onNavAnimationStart() {}

  void onNavAnimationComplete() {}

  void onNavAnimationReverse() {
    removeStatusListener();
  }

  void _animationStatusListener(AnimationStatus s) {
    var oldStatus = _navAnimationStatus;
    _navAnimationStatus = s;
    if (oldStatus == _navAnimationStatus) {
      return;
    }
    if (_navAnimationStatus == AnimationStatus.forward) {
      onNavAnimationStart();
    } else if (_navAnimationStatus == AnimationStatus.completed) {
      onNavAnimationComplete();
    } else if (_navAnimationStatus == AnimationStatus.reverse) {
      onNavAnimationReverse();
    }
  }
}

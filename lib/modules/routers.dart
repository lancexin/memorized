import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_ui/memo_ui.dart';
import 'package:memorized/modules/home/home_page.dart';
import 'package:memorized/core/init/providers.dart';
import 'package:memorized/modules/welcome/welcome_page.dart';

import 'car_select/car_select_page.dart';
import 'gesture_bottom/gesture_bottom_page.dart';
import 'gesture_left/gesture_left_page.dart';
import 'login/login_page.dart';
import 'bottom_sheet_action1/bottom_sheet_action1.dart';
import 'alert_dialog_action1/alert_dialog_action1.dart';
import 'splash/splash_page.dart';
import 'loading/loading_page.dart';
import 'test1/test1_page.dart';
import 'test2/test2_page.dart';

class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    debugPrint("didStartUserGesture");
  }

  @override
  void didStopUserGesture() {
    debugPrint("didStopUserGesture");
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint("didPush");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint("didReplace");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint("didPop");
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugPrint("didRemove");
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = MemoRouter(ref);
  return GoRouter(
      refreshListenable: router,
      redirect: router.redirect,
      debugLogDiagnostics: true,
      observers: [AppNavigatorObserver()],
      routes: router.routes);
});

class MemoRouter extends ChangeNotifier {
  static const String root = "/";
  static const String welcome = "/welcome";
  static const String home = "/home";
  static const String login = "/login";
  static const String gestureLeft = "/gestureLeft";
  static const String gestureBottom = "/gestureBottom";
  static const String bottomSheetAction1 = "/bottomSheetAction1";
  static const String loading = "/loading";
  static const String showDialogAction1 = "/showDialogAction1";
  static const String test1 = "/test1";
  static const String test2 = "/test2";
  static const String carSelect = "/carSelect";

  final Ref _ref;
  MemoRouter(this._ref) {
    _ref.listen(
      initProvider,
      (_, __) => notifyListeners(),
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final initState = _ref.read(initProvider);

    //init start
    if (state.matchedLocation == root) {
      return initState.maybeWhen(data: (b) {
        //init complete
        return home;
      }, orElse: () {
        return null;
      });
    }
    return null;
  }

  List<GoRoute> get routes {
    return [
      GoRoute(
        name: root,
        path: root,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: welcome,
        path: welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        name: carSelect,
        path: carSelect,
        builder: (context, state) => const CarSelectPage(),
      ),
      GoRoute(
        name: home,
        path: home,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: login,
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: test1,
        path: test1,
        pageBuilder: (context, state) {
          return TransitionPage(
            key: state.pageKey,
            //  fullscreenDialog: true,
            child: const Test1Page(),
          );
        },
      ),
      GoRoute(
        name: test2,
        path: test2,
        pageBuilder: (context, state) {
          return TransitionPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const Test2Page(),
          );
        },
      ),
      GoRoute(
        name: gestureLeft,
        path: gestureLeft,
        pageBuilder: (context, state) {
          return TransitionPage(
            transitionDuration: const Duration(seconds: 3),
            key: state.pageKey,
            child: const GestureLeftPage(),
          );
        },
      ),
      GoRoute(
        name: gestureBottom,
        path: gestureBottom,
        pageBuilder: (context, state) {
          return TransitionPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const GestureBottomPage(),
          );
        },
      ),
      GoRoute(
        name: loading,
        path: loading,
        pageBuilder: (context, state) {
          return TransitionPage(
            key: state.pageKey,
            child: const LoadingPage(),
          );
        },
      ),
      GoRoute(
        name: bottomSheetAction1,
        path: bottomSheetAction1,
        pageBuilder: (context, state) {
          return BottomSheetPage(
            key: state.pageKey,
            useRootNavigator: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (BuildContext context) {
              return const BottomSheetAction1();
            },
          );
        },
      ),
      GoRoute(
        name: showDialogAction1,
        path: showDialogAction1,
        pageBuilder: (context, state) {
          return AlertDialogPage(
            key: state.pageKey,
            useRootNavigator: true,
            useSafeArea: true,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return const AlertDialogAction1();
            },
          );
        },
      ),
    ];
  }
}

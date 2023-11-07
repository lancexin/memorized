import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memorized/core/theme/theme.dart';
import 'package:memorized/core/theme/providers.dart';

import '../modules/routers.dart';

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final colorSelected = ref.watch(colorSeedProvider);
    return MaterialApp.router(
      themeMode: themeMode,
      theme: AppTheme.light.copyWith(
          colorScheme: ColorScheme.fromSeed(
        seedColor: colorSelected.color,
        brightness: Brightness.light,
      )),
      darkTheme: AppTheme.dark.copyWith(
          colorScheme: ColorScheme.fromSeed(
        seedColor: colorSelected.color,
        brightness: Brightness.dark,
      )),
      routerConfig: router,
    );
  }
}

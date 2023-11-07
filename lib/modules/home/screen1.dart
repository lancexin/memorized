import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/providers.dart';
import '../../core/theme/theme.dart';
import '../routers.dart';
import 'home_page.dart';

class Screen1 extends ConsumerWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _body(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Memorized"),
      actions: [_BrightnessButton(), _ThemeColorButton()],
    );
  }

  Widget _item(String label, void Function() onPressd) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: FilledButton(onPressed: onPressd, child: Text(label)));
  }

  Widget _body(BuildContext context) {
    return Scrollbar(
        child: ListView(
      primary: true,
      children: [
        const Hero(
            tag: "logo",
            child: FlutterLogo(
              size: 100,
            )),
        _item("汽车选择器", () async {
          await context.push(MemoRouter.carSelect);
        }),
        _item("懒加载防卡顿", () async {
          await context.push(MemoRouter.gestureLeft);
        }),
        _item("从下方划上", () async {
          await context.push(MemoRouter.gestureBottom);
        }),
        _item("复杂布局1", () async {
          await context.push(MemoRouter.test1);
        }),
        _item("复杂布局2", () async {
          await context.push(MemoRouter.test2);
        }),
        _item("router管理 dialog", () async {
          await context.push(MemoRouter.showDialogAction1);
        }),
        _item("router管理 bottomSheet", () async {
          await context.push(MemoRouter.bottomSheetAction1);
        }),
        _item("shimmerLoading", () async {
          await context.push(MemoRouter.loading);
        }),
      ],
    ));
  }
}

class _BrightnessButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isLightMode = _isLightMode(context, themeMode);

    return IconButton(
      icon: isLightMode
          ? const Icon(Icons.dark_mode_outlined)
          : const Icon(Icons.light_mode_outlined),
      onPressed: () {
        ref.read(themeModeProvider.notifier).state =
            isLightMode ? ThemeMode.dark : ThemeMode.light;
      },
    );
  }

  bool _isLightMode(BuildContext context, ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }
}

class _ThemeColorButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorSelected = ref.watch(colorSeedProvider);
    return PopupMenuButton(
      icon: Icon(
        Icons.palette_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      tooltip: 'Select a seed color',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) {
        return List.generate(AppColorSeed.values.length, (index) {
          AppColorSeed currentColor = AppColorSeed.values[index];

          return PopupMenuItem(
            value: index,
            enabled: currentColor != colorSelected,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    currentColor == colorSelected
                        ? Icons.color_lens
                        : Icons.color_lens_outlined,
                    color: currentColor.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(currentColor.label),
                ),
              ],
            ),
          );
        });
      },
      onSelected: (index) {
        ref.read(colorSeedProvider.notifier).state = AppColorSeed.values[index];
      },
    );
  }
}

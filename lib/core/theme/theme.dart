import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      actionIconTheme: _actionIconThemeData);

  static ThemeData get light => ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      actionIconTheme: _actionIconThemeData);

  static const ActionIconThemeData _actionIconThemeData = ActionIconThemeData(
      backButtonIconBuilder: _backButtonIconBuilder,
      closeButtonIconBuilder: _closeButtonIconBuilder);

  static Widget _backButtonIconBuilder(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: const Icon(Icons.arrow_back),
    );
  }

  static Widget _closeButtonIconBuilder(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: const RotatedBox(
          quarterTurns: -45, child: Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }
}

enum AppColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const AppColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

final colorSeedProvider = StateProvider<AppColorSeed>((ref) {
  return AppColorSeed.baseColor;
});

final navIndexProvider = StateProvider<int>((ref) {
  return 0;
});

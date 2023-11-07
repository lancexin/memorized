import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app.dart';
import 'package:design_size/design_size.dart';

void main() {
  //适配设计稿
  DesignSizeWidgetsFlutterBinding.ensureInitialized(const Size(375, 667));

  runApp(
    const ProviderScope(child: App()),
  );
}

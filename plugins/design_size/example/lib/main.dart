import 'dart:io';

import 'package:design_size_example/page1.dart';
import 'package:design_size_example/page2.dart';
import 'package:flutter/material.dart';
import 'package:design_size/design_size.dart';
import 'package:flutter/services.dart';

void main() {
  DesignSizeWidgetsFlutterBinding.ensureInitialized(const Size(375, 667));
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      initialRoute: "/page1",
      routes: {
        "/page1": (context) => const Page1(),
        "/page2": (context) => const Page2()
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Screen2 extends ConsumerStatefulWidget {
  const Screen2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Screen2State();
}

class _Screen2State extends ConsumerState<Screen2> {
  @override
  Widget build(BuildContext context) {
    Colors.accents;
    return const Center(
      child: Text("Screen2"),
    );
  }
}

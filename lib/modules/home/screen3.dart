import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Screen3 extends ConsumerStatefulWidget {
  const Screen3({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Screen3State();
}

class _Screen3State extends ConsumerState<Screen3> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Screen3"),
    );
  }
}

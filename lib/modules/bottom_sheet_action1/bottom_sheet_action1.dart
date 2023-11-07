import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomSheetAction1 extends ConsumerWidget {
  const BottomSheetAction1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 28,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      size: 28,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 28,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.archive_outlined,
                      size: 28,
                    )),
              ],
            )));
  }
}

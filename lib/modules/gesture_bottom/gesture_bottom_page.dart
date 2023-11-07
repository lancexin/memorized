import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_ui/memo_ui.dart';
import 'package:memorized/core/init/providers.dart';

class GestureBottomPage extends ConsumerStatefulWidget {
  const GestureBottomPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

var test1Counter = StateProvider.autoDispose((ref) => 0);

class _State extends ConsumerState<GestureBottomPage> with NavAnamationMixin {
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    var stroageService = ref.read(stroageServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, ref, _) {
          return Text("GestureBottomPage ${ref.watch(test1Counter)}");
        }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Hero(
                tag: "logo",
                child: FlutterLogo(
                  size: 200,
                )),
            loaded
                ? Image.file(
                    File(stroageService.getCacheFilePath("013_28-1.jpg")))
                : SizedBox.shrink(),
            Consumer(builder: (context, ref, _) {
              return Text(
                "${ref.watch(test1Counter)}",
                style: Theme.of(context).textTheme.headlineMedium,
              );
            })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pop(),
        tooltip: 'Increment',
        child: const Icon(Icons.backspace),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Timer? timer;
  @override
  void onNavAnimationComplete() {
    super.onNavAnimationComplete();
    ref.read(test1Counter.notifier).state++;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        ref.read(test1Counter.notifier).state++;
      }
    });
  }

  @override
  void onNavAnimationReverse() {
    super.onNavAnimationReverse();
    timer?.cancel();
    timer = null;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_ui/memo_ui.dart';

class GestureLeftPage extends ConsumerStatefulWidget {
  const GestureLeftPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

var test1Counter = StateProvider.autoDispose((ref) => 0);

class _State extends ConsumerState<GestureLeftPage> with NavAnamationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, ref, _) {
          return Text("GestureLeftPage ${ref.watch(test1Counter)}");
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
            const Text(
              "转场动画结束后才会开始计数\n用此种方法可以监听Navigator的转场动画",
              textAlign: TextAlign.center,
            ),
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
        onPressed: () async {
          // var result = await ref.read(dataSource177Provider).index();
          // if (result.isFailure) {
          //   Log.d(result.failure.message);
          // }
        },
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

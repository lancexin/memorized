import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef StringProvider = StateProvider<String>;
typedef IntProvider = StateProvider<int>;
typedef DoubleProvider = StateProvider<double>;
typedef BoolProvider = StateProvider<bool>;

extension StringExtension on String {
  StringProvider get obs => StringProvider((ref) => this);
}

extension IntExtension on int {
  IntProvider get obs => IntProvider((ref) => this);
}

extension DoubleExtension on double {
  DoubleProvider get obs => DoubleProvider((ref) => this);
}

extension BoolExtension on bool {
  BoolProvider get obs => BoolProvider((ref) => this);
}

extension TExtension<T> on T {
  Provider<T> get obs => Provider<T>((ref) => this);
}

var counter = 0.obs;

class TestWidget extends ConsumerWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int c = ref.watch(counter);

    ref.read(counter.notifier).state++;
    return Container();
  }
}

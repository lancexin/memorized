import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/screen1.dart';
import '../../core/theme/providers.dart';
import 'screen2.dart';
import 'screen3.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Screens(),
      bottomNavigationBar: _NavgationBars(),
    );
  }
}

class _Screens extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navIndexProvider);
    return screens[selectedIndex];
  }

  final screens = const [
    Screen1(),
    Screen2(),
    Screen3(),
  ];
}

class _NavgationBars extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navIndexProvider);
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        ref.read(navIndexProvider.notifier).state = index;
      },
      destinations: appDestinations,
    );
  }

  static const List<Widget> appDestinations = [
    NavigationDestination(
      tooltip: '',
      icon: Icon(Icons.explore_outlined),
      label: 'Screen1',
      selectedIcon: Icon(Icons.explore),
    ),
    NavigationDestination(
      tooltip: '',
      icon: Icon(Icons.pets_outlined),
      label: 'Screen2',
      selectedIcon: Icon(Icons.pets),
    ),
    NavigationDestination(
      tooltip: '',
      icon: Icon(Icons.account_box_outlined),
      label: 'Screen3',
      selectedIcon: Icon(Icons.account_box),
    )
  ];
}
